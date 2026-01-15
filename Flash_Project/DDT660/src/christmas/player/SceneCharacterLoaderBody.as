package christmas.player
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class SceneCharacterLoaderBody
   {
      
      private var _loaders:Vector.<ChristmasSceneCharacterLayer>;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      private var _content:BitmapData;
      
      private var _playerInfo:PlayerInfo;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      private var _callBack:Function;
      
      public function SceneCharacterLoaderBody(playerInfo:PlayerInfo)
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
         this._loaders = new Vector.<ChristmasSceneCharacterLayer>();
         this._recordStyle = this._playerInfo.Style.split(",");
         this._recordColor = this._playerInfo.Colors.split(",");
         this._loaders.push(new ChristmasSceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],1,this._playerInfo.Sex));
         this._loaders.push(new ChristmasSceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],2,this._playerInfo.Sex));
      }
      
      private function drawCharacter() : void
      {
         var picWidth:Number = this._loaders[0].width;
         var picHeight:Number = this._loaders[0].height;
         if(picWidth == 0 || picHeight == 0)
         {
            return;
         }
         this._content = new BitmapData(picWidth,picHeight,true,0);
         for(var i:uint = 0; i < this._loaders.length; i++)
         {
            if(!this._loaders[i].isAllLoadSucceed)
            {
               this._isAllLoadSucceed = false;
            }
            this._content.draw(this._loaders[i].getContent(),null,null,BlendMode.NORMAL);
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

