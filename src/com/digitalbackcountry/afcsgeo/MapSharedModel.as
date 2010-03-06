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
	import com.adobe.rtc.events.CollectionNodeEvent;
	import com.adobe.rtc.events.SharedModelEvent;
	import com.adobe.rtc.messaging.MessageItem;
	import com.adobe.rtc.session.ConnectSession;
	import com.adobe.rtc.sharedModel.Baton;
	import com.adobe.rtc.sharedModel.CollectionNode;
	import com.google.maps.LatLng;
	import com.google.maps.MapEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import model.ApplicationSharedModel;
	
	public class MapSharedModel extends EventDispatcher
	{
		[Event(name="batonChange", type="flash.events.Event")]
		[Event(name="positionChange", type="flash.events.Event")]
		[Event(name="zoomChange", type="com.google.maps.MapEvent")]
		
		//public static const POSITION_CHANGE:String = "positionChange";
		
		// Collection node for storing our map state info (position, movement, etc)
		protected var _collectionNode:CollectionNode;
		protected var _baton:Baton;
		protected var _myUserID:String;
		protected var _batonHolder:String;
		protected var _waypointCollection:CollectionNode;
		
		protected var _position:LatLng;
		protected var _zoom:Number;
		
		// we use this to publish our messages, so making it a static const helps keep things straight
		protected static const MAP_POSITION_NODE:String = "positionNode";
		protected static const MAP_ZOOM_NODE:String = "zoomNode";
		
		public function MapSharedModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function subscribe(collectionNodeID:String):void
		{
			_myUserID = ConnectSession.primarySession.userManager.myUserID;
			
			_collectionNode = new CollectionNode();
			_collectionNode.sharedID = collectionNodeID;
			_collectionNode.addEventListener(CollectionNodeEvent.SYNCHRONIZATION_CHANGE,onSyncChange);
			_collectionNode.addEventListener(CollectionNodeEvent.ITEM_RECEIVE,onItemReceive);
			_collectionNode.subscribe();
			
			_baton = new Baton();
			_baton.sharedID = "mapBaton";
			_baton.timeOut = 10;
			_baton.collectionNode = _collectionNode;
			_baton.subscribe();
			_baton.addEventListener(SharedModelEvent.BATON_HOLDER_CHANGE,onBatonHolderChange);
			
		}
		
		public function set position(value:LatLng):void
		{
			if( _baton.amIHolding )
			{
				_baton.extendTimer();
			} else if ( _baton.canIGrab ) 
			{
				_baton.grab();
			} else 
			{
				return;	
			}
			
			var msgItem:MessageItem = new MessageItem(MAP_POSITION_NODE,{lat:value.lat(),lng:value.lng()});
				_collectionNode.publishItem(msgItem);
		}
		
		[Bindable("positionChange")]
		public function get position():LatLng
		{
			return _position;
		}
		
		public function set zoom(value:Number):void
		{
			if( _baton.amIHolding )
			{
				_baton.extendTimer();
			} else if ( _baton.canIGrab )
			{
				_baton.grab();
			} else
			{
				return;
			}
			
			var msgItem:MessageItem = new MessageItem(MAP_ZOOM_NODE,value);
				_collectionNode.publishItem(msgItem);
		}
		
		[Bindable("zoomChange")]
		public function get zoom():Number
		{
			return _zoom;
		}
		
		[Bindable("batonChange")]
		public function get batonHolder():String
		{
			return _batonHolder;
		}
		
		protected function onSyncChange(event:CollectionNodeEvent):void
		{
			if(!_collectionNode.isNodeDefined(MAP_POSITION_NODE))
			{
				_collectionNode.createNode(MAP_POSITION_NODE);		
			}
		}
		
		protected function onItemReceive(event:CollectionNodeEvent):void
		{
			if( event.nodeName == MAP_POSITION_NODE )
			{
				_position = new LatLng(event.item.body.lat,event.item.body.lng);
				if(event.item.publisherID != _myUserID)
				{
					dispatchEvent(new Event("positionChange"));
				}
			} else if ( event.nodeName == MAP_ZOOM_NODE )
			{
				_zoom = event.item.body;
				if( event.item.publisherID != _myUserID )
				{
					dispatchEvent(new Event("zoomChange"));
				}
			}
			
		}
		
		protected function onBatonHolderChange(event:SharedModelEvent):void
		{
			_batonHolder = _baton.holderID;
			dispatchEvent(new Event("batonChange"));
		}
	}
}