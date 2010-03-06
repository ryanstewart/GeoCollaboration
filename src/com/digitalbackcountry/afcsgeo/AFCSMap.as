/*
Copyright (c) 2010 Ryan Stewart
http://blog.digitalbackcountry.com

----------------------------------------------------------------------------
"THE BEER-WARE LICENSE" (Revision 42):
<ryan@ryanstewart.net> wrote this file. As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return =Ryan Stewart
----------------------------------------------------------------------------

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/


package com.digitalbackcountry.afcsgeo
{
	import com.adobe.gpslib.gpx.Waypoint;
	import com.adobe.rtc.events.CollectionNodeEvent;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapAction;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapType;
	import com.google.maps.MapZoomEvent;
	import com.google.maps.overlays.Marker;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.ApplicationSharedModel;
	
	import mx.controls.Label;
	
	public class AFCSMap extends Map
	{
		
		protected var _sharedModel:MapSharedModel;
		protected var _appSharedModel:ApplicationSharedModel;
		
		public function AFCSMap()
		{
			super();
			addEventListener(MapMouseEvent.DOUBLE_CLICK,onMapDoubleClick);
			addEventListener(MapEvent.MAP_READY, onMapReady);
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			addEventListener(MapZoomEvent.ZOOM_CHANGED,onMapZoomChange);
		}

		protected function onMapReady(event:MapEvent):void
		{
			this.setDoubleClickMode(MapAction.ACTION_NOTHING);
			
			_sharedModel = new MapSharedModel();
			_sharedModel.subscribe("googleMap");
			_sharedModel.addEventListener("positionChange",onModelPositionChange);
			_sharedModel.addEventListener("zoomChange",onModelZoomChange);
			
			_appSharedModel = new ApplicationSharedModel();
			_appSharedModel.subscribe();
			_appSharedModel.addEventListener(CollectionNodeEvent.ITEM_RECEIVE,onWaypointChange);
			
			var label:Label = new Label();
			label.right = width;
			label.bottom = height;			
			
			//onMapPositionChange();
			setCenter(new LatLng(0,0),4,MapType.PHYSICAL_MAP_TYPE);
		}
		
		protected function onMapDoubleClick(event:MapMouseEvent):void
		{
			
			var wpt:Waypoint = new Waypoint(event.latLng.lat(),event.latLng.lng());
			_appSharedModel.addWaypoint(wpt);
		}
		
		protected function onModelPositionChange(event:Event=null):void
		{
			if( _sharedModel.position )
			{
				if( this.isLoaded() )
				{
					setCenter(_sharedModel.position);	
				}
				
			}
		}
		
		protected function onModelZoomChange(event:Event=null):void
		{
			if( _sharedModel.zoom )
			{
				if( this.isLoaded() )
				{
					setZoom(_sharedModel.zoom);
				}
			}
		}
		
		protected function onMouseMove(event:Event):void
		{
			_sharedModel.position = getCenter();
		}
		
		protected function onMapZoomChange(event:MapZoomEvent):void
		{
			_sharedModel.zoom = event.zoomLevel;
		}
		
		protected function onWaypointChange(event:CollectionNodeEvent):void
		{
			if(isLoaded())
			{
				var latLng:LatLng = new LatLng(event.item.body.latitude,event.item.body.longitude);
				this.addOverlay(new Marker(latLng));
			}
		}
	}
}