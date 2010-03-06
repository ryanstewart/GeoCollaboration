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
	
	import mx.collections.ArrayCollection;
	
	[Event(name="synchronizationChange", type="com.adobe.rtc.events.CollectionNodeEvent")]
			
	
	public class WaypointSharedCollection extends ArrayCollection
	{
		
		
		public function WaypointSharedCollection(source:Array=null)
		{
			super(source);
		}
	}
}