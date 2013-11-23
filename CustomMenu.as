package 
{
	import flash.display.NativeMenu;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.NativeMenuItem;
	
	public class CustomMenu extends NativeMenu{
		
		private var config:XML, configUrl:String;
		private var configFile:File, configLoader:URLLoader
		
		public function CustomMenu(configUrl:String = null):void{
			if(configUrl == null){
				configUrl = File.applicationDirectory.url;
			}
			setConfig(configUrl);
		}
		
		public function setConfig(configUrl:String):void{
			this.configUrl = configUrl
			configFile = new File(configUrl);
			if(configFile.exists && !configFile.isDirectory){
				configLoader = new URLLoader(new URLRequest(configFile.url));
				configLoader.addEventListener(Event.COMPLETE, configLoaded);
			}
			else{
				dispatchEvent(new CustomEvent(CustomEvent.NOT_EXISTING));
			}
		}
		
		private function configLoaded(e:Event):void{
			config = new XML(e.target.data);
			removeAllItems();
			createMenu(this, config.children());
			dispatchEvent(new CustomEvent(CustomEvent.LOADED));
		}
		
		private function createMenu(menu:NativeMenu, xmlList:XMLList):void{
			for(var i:int = 0; i < xmlList.length(); i++){
				//trace(xmlList[i].@name, xmlList[i].@shortcut, Boolean(Number(xmlList[i].@separator)));
				var menuItem:NativeMenuItem = createMenuItem(xmlList[i].@name, xmlList[i].@shortcut, Default.parseBoolean(xmlList[i].@separator));
				if(Default.parseBoolean(xmlList[i].@modify)){
					menuItem.keyEquivalentModifiers = [];
				}
				menuItem.name = xmlList[i].@name;
				menu.addItem(menuItem);
				if(xmlList[i].hasComplexContent()){
					var subMenu:NativeMenu = new NativeMenu();
					menuItem.submenu = subMenu;
					createMenu(menuItem.submenu, xmlList[i].children());
				}
			}
		}
		
		private function createMenuItem(name:String, shortcut:String, isSeparator:Boolean):NativeMenuItem{
			var menuItem:NativeMenuItem = new NativeMenuItem(name, isSeparator);
			menuItem.keyEquivalent = shortcut;
			return menuItem;
		}
		
		public function selectOnlyFrom(item:NativeMenuItem, menu:NativeMenu):void{//:Boolean{
			if(menu.containsItem(item)){
				for(var i:int = 0; i < menu.numItems; i++){
					if(item == menu.getItemAt(i)){
						menu.getItemAt(i).checked = true;
					}
					else{
						menu.getItemAt(i).checked = false;
					}
				}
			}
			//return menu.containsItem(item);
		}
		
	}
	
}