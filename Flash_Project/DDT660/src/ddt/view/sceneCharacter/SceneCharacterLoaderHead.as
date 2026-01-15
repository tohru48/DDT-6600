package ddt.view.sceneCharacter
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class SceneCharacterLoaderHead
   {
      
      private var _loaders:Vector.<SceneCharacterLayer>;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      private var _content:BitmapData;
      
      private var _completeCount:int;
      
      private var _playerInfo:PlayerInfo;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      private var _callBack:Function;
      
      public function SceneCharacterLoaderHead(playerInfo:PlayerInfo)
      {
         super();
         this._playerInfo = playerInfo;
      }
      
      public function load(callBack:Function = null) : void
      {
         this._callBack = callBack;
         if(this._playerInfo == null || this._playerInfo.Style == null)
         {
            return;
         }
         this.initLoaders();
         var loaderCount:int = int(this._loaders.length);
         for(var i:int = 0; i < loaderCount; i++)
         {
            this._loaders[i].load(this.layerComplete);
         }
      }
      
      private function initLoaders() : void
      {
         this._loaders = new Vector.<SceneCharacterLayer>();
         this._recordStyle = this._playerInfo.Style.split(",");
         this._recordColor = this._playerInfo.Colors.split(",");
         this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5]));
         this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])),this._recordColor[2]));
         this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])),this._recordColor[3]));
      }
      
      private function drawCharacter() : void
      {
         var layer:SceneCharacterLayer = null;
         var picWidth:Number = this._loaders[0].width;
         var picHeight:Number = this._loaders[0].height;
         if(picWidth == 0 || picHeight == 0)
         {
            return;
         }
         this._content = new BitmapData(picWidth,picHeight,true,0);
         for(var i:uint = 0; i < this._loaders.length; i++)
         {
            layer = this._loaders[i];
            if(!layer.isAllLoadSucceed)
            {
               this._isAllLoadSucceed = false;
            }
            this._content.draw(layer.getContent(),null,null,BlendMode.NORMAL);
         }
      }
      
      private function layerComplete(layer:ILayer) : void
      {
         var isAllLayerComplete:Boolean = true;
         for(var i:int = 0; i < this._loaders.length; i++)
         {
            if(!this._loaders[i].isComplete)
            {
               isAllLayerComplete = false;
            }
         }
         if(isAllLayerComplete)
         {
            this.drawCharacter();
            this.loadComplete();
         }
      }
      
      private function loadComplete() : void
      {
         if(this._callBack != null)
         {
            this._callBack(this,this._isAllLoadSucceed);
         }
      }
      
      public function getContent() : Array
      {
         return [this._content];
      }
      
      public function dispose() : void
      {
         if(this._loaders == null)
         {
            return;
         }
         for(var i:int = 0; i < this._loaders.length; i++)
         {
            this._loaders[i].dispose();
         }
         this._loaders = null;
         this._recordStyle = null;
         this._recordColor = null;
         this._playerInfo = null;
         this._callBack = null;
      }
   }
}

