package com.pickgliss.loader
{
	import com.pickgliss.ui.ComponentSetting;
	import com.pickgliss.utils.ClassUtils;
	import flash.utils.Dictionary;
	
	public class CodeLoader
	{
		
		private static var _loadedDic:Dictionary = new Dictionary();
		
		
		private const DDT_CLASS_PATH:String = "DDT";
		
		private var _onLoaded:Function;
		
		private var _url:String;
		
		private var _onProgress:Function;
		
		private var _coreLoader:BaseLoader;
		
		public function CodeLoader()
		{
			super();
		}
		
		public static function loaded(url:String) : Boolean
		{
			return _loadedDic[url] != null;
		}
		
		public static function removeURL(url:String) : void
		{
			delete _loadedDic[url];
		}
		
		public function loadPNG($url:String, $onLoaded:Function, $onProgress:Function) : void
		{
			this._url = $url;
			this._onLoaded = $onLoaded;
			this._onProgress = $onProgress;
			this.startLoad();
		}
		
		public function stop() : void
		{
			this._coreLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onloadCoreComplete);
			this._coreLoader.removeEventListener(LoaderEvent.PROGRESS,this.__onLoadCoreProgress);
		}
		
		private function startLoad() : void
		{
			var url:String = ComponentSetting.FLASHSITE + this._url;
			this._coreLoader = LoadResourceManager.Instance.createLoader(url,BaseLoader.MODULE_LOADER);
			this._coreLoader.addEventListener(LoaderEvent.COMPLETE,this.__onloadCoreComplete);
			this._coreLoader.addEventListener(LoaderEvent.PROGRESS,this.__onLoadCoreProgress);
			LoadResourceManager.Instance.startLoad(this._coreLoader);
		}
		
		protected function __onLoadCoreProgress(event:LoaderEvent) : void
		{
			this._onProgress(event.loader.progress);
		}
		
		private function __onloadCoreComplete(event:LoaderEvent) : void
		{
			event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onloadCoreComplete);
			event.loader.removeEventListener(LoaderEvent.PROGRESS,this.__onLoadCoreProgress);
			var ddtCoreInstance:* = ClassUtils.CreatInstance(this.DDT_CLASS_PATH);
			if(ddtCoreInstance != null)
			{
				LoaderSavingManager.saveFilesToLocal();
				ddtCoreInstance["setup"]();
				_loadedDic[this._url] = 1;
				if(this._onLoaded != null)
				{
					this._onLoaded();
				}
				this._coreLoader = null;
				this._onLoaded = null;
				this._onProgress = null;
				return;
			}
			throw "断网了，请刷新页面重试。";
		}
	}
}
