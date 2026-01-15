package consortionBattle.player
{
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class ConsBatLoaderHeadOrBody
   {
      
      private var _loaders:Vector.<ConsBattSceneCharacterLayer>;
      
      private var _content:BitmapData;
      
      private var _completeCount:int;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      private var _callBack:Function;
      
      private var _consBatPlayerData:ConsortiaBattlePlayerInfo;
      
      private var _equipType:int;
      
      public function ConsBatLoaderHeadOrBody(playerData:ConsortiaBattlePlayerInfo, equipType:int)
      {
         super();
         this._consBatPlayerData = playerData;
         this._equipType = equipType;
      }
      
      public function load(callBack:Function = null) : void
      {
         this._callBack = callBack;
         this.initLoaders();
         var loaderCount:int = int(this._loaders.length);
         for(var i:int = 0; i < loaderCount; i++)
         {
            this._loaders[i].load(this.layerComplete);
         }
      }
      
      private function initLoaders() : void
      {
         this._loaders = new Vector.<ConsBattSceneCharacterLayer>();
         if(this._equipType == 1)
         {
            this._loaders.push(new ConsBattSceneCharacterLayer(ItemManager.Instance.getTemplateById(5361),1,this._consBatPlayerData.sex,this._consBatPlayerData.clothIndex,1));
            this._loaders.push(new ConsBattSceneCharacterLayer(ItemManager.Instance.getTemplateById(5361),3,this._consBatPlayerData.sex,this._consBatPlayerData.clothIndex,1));
         }
         else
         {
            this._loaders.push(new ConsBattSceneCharacterLayer(ItemManager.Instance.getTemplateById(5361),2,this._consBatPlayerData.sex,this._consBatPlayerData.clothIndex,1));
            this._loaders.push(new ConsBattSceneCharacterLayer(ItemManager.Instance.getTemplateById(5361),2,this._consBatPlayerData.sex,this._consBatPlayerData.clothIndex,2));
         }
      }
      
      private function drawCharacter() : void
      {
         var layer:ConsBattSceneCharacterLayer = null;
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
         this._consBatPlayerData = null;
         this._callBack = null;
      }
   }
}

