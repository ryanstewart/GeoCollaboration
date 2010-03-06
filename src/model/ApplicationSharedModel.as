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


package model
{
	import afcs.collections.SharedArrayCollection;
	
	import com.adobe.gpslib.gpx.Waypoint;
	import com.adobe.rtc.events.CollectionNodeEvent;
	import com.adobe.rtc.session.ConnectSession;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class ApplicationSharedModel extends EventDispatcher
	{
		[Event(name="waypointChange",type="com.adobe.rtc.events.CollectionNodeEvent")]
		
		//protected var _waypointCollection:CollectionNode;
		protected var _sharedWaypoints:SharedArrayCollection;
		//protected var _arrWaypoints:ArrayCollection;
		protected var _myUserID:String;
		
		protected static const WAYPOINTS_NODE:String = "waypointsNode";
		
		public function ApplicationSharedModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function subscribe():void
		{
			//_arrWaypoints = new ArrayCollection();
			
			_myUserID = ConnectSession.primarySession.userManager.myUserID;
			
			_sharedWaypoints = new SharedArrayCollection();
			_sharedWaypoints.subscribe("waypointsArray");
			_sharedWaypoints.addEventListener(CollectionNodeEvent.ITEM_RECEIVE,onWaypointItemReceive);

			
			/*
			_waypointCollection = new CollectionNode();
			_waypointCollection.sharedID = "waypointNodes";
			_waypointCollection.addEventListener(CollectionNodeEvent.ITEM_RECEIVE,onWaypointItemReceive);
			_waypointCollection.addEventListener(CollectionNodeEvent.SYNCHRONIZATION_CHANGE,onWaypointSyncChange);
			_waypointCollection.subscribe();
			*/
		}
		
		[Bindable("waypointChange")]
		public function get sharedWaypoints():ArrayCollection
		{
			return _sharedWaypoints;
			//return _arrWaypoints;
		}
		
		public function addWaypoint(wpt:Waypoint):void
		{
			
			//var wptItem:WaypointItem = new WaypointItem(WAYPOINTS_NODE,wpt,new String(wpt.latitude + wpt.longitude));
			_sharedWaypoints.addItem(wpt);
			//_waypointCollection.publishItem(wptItem);
		}
		
		public function removeWaypoint(wpt:Waypoint):void
		{
			
		}
		
		public function removeWaypointAt(index:Number):void
		{
			
		}
		
		protected function onWaypointItemReceive(event:CollectionNodeEvent):void
		{
			dispatchEvent(event);
		}
		
		protected function onWaypointSyncChange(event:CollectionNodeEvent):void
		{
			trace('test sync');
		}
	}
}