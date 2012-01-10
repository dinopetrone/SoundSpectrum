package com.blitzagency.fabric.contextMenu 
{
	import com.blitzagency.fabric.FabricGateway;
	import com.blitzagency.fabric.INavigation;
	import com.blitzagency.fabric.IPage;

	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;

	/**
	 * @author dinopetrone
	 */
	public class TreeContextMenu  
	{
		private var _displayObj:DisplayObjectContainer;
		private var _contextMenu:ContextMenu;
		private var _enable:Boolean;
		private var _navObj:Object = {};

		public function TreeContextMenu(dispOjb:DisplayObjectContainer) 
		{
			_displayObj = dispOjb;
			_contextMenu = new ContextMenu();
			removeDefaultItems();
			_displayObj.contextMenu = _contextMenu;
		}

		private function removeDefaultItems():void 
		{
			_contextMenu.hideBuiltInItems();
			var defaultItems:ContextMenuBuiltInItems = _contextMenu.builtInItems;
		}

		private function addCustomMenuItems():void 
		{
			getTree(INavigation(Object(_displayObj).navigation).tree);
		}

		
		private function getTree(nav:IPage,location:String = "",depth:int = 0):void
		{
			
			var cmTitle:String = depth == 0 ? "/" : getTabs(depth) + nav.title;
			var cmLocation:String = depth == 0 ? "" : location + nav.id + "/";
			var item:ContextMenuItem = new ContextMenuItem(cmTitle);
			_navObj[cmTitle] = cmLocation; 
			_contextMenu.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler); 
			for (var i:int = 0;i < nav.pages.length;i++) 
			{
				var newLoc:String = depth == 0 ? "" : location + nav.id + "/";
				getTree(nav.pages[i], newLoc, depth + 1);
			}
		}

		private function getTabs(num:int):String
		{
			var tabStr:String = '';
			while(num > 0)
			{
				num--;
				tabStr += "~";
			}
			return tabStr;
		}

		
		private function removeCustomMenuItems():void 
		{
			var cm = new ContextMenu();
			_displayObj.contextMenu = cm;
			cm.hideBuiltInItems();
			var defaultItems:ContextMenuBuiltInItems = cm.builtInItems;
		}

		private function menuItemSelectHandler(event:ContextMenuEvent):void 
		{
			if(FabricGateway.fabric.navigation.location == _navObj[event.target.caption])return;
			FabricGateway.fabric.navigation.location = _navObj[event.target.caption]; 
		}

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(enable:Boolean):void
		{
			_enable = enable;
			if(_enable)
			{
				addCustomMenuItems();
			}
			else
			{
				removeCustomMenuItems();
			}
		}
	}
}
