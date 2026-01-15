package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class LoaderHeadOrBody
   {
      
      private var _loaders:Array;
      
      private var _content:BitmapData;
      
      private var _completeCount:int;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      private var _callBack:Function;
      
      private var _consBatPlayerData:RoleData;
      
      private var _equipType:int;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      public function LoaderHeadOrBody(roleData:RoleData, equipType:int)
      {
         super();
         this._consBatPlayerData = roleData;
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
         this._loaders = new Array();
         if(this._equipType == 1)
         {
            this._loaders.push(new CampBattleCharacterLayer(ItemManager.Instance.getTemplateById(5361),0,this._consBatPlayerData.Sex,this._consBatPlayerData.team,1,this._consBatPlayerData.baseURl,this._consBatPlayerData.MountsType));
            this._loaders.push(new CampBattleCharacterLayer(ItemManager.Instance.getTemplateById(5361),1,this._consBatPlayerData.Sex,this._consBatPlayerData.team,1,this._consBatPlayerData.baseURl,this._consBatPlayerData.MountsType));
         }
         else
         {
            this._loaders.push(new CampBattleCharacterLayer(ItemManager.Instance.getTemplateById(5361),this._equipType,this._consBatPlayerData.Sex,this._consBatPlayerData.team,1,this._consBatPlayerData.baseURl,this._consBatPlayerData.MountsType));
            this._loaders.push(new CampBattleCharacterLayer(ItemManager.Instance.getTemplateById(5361),this._equipType,this._consBatPlayerData.Sex,this._consBatPlayerData.team,2,this._consBatPlayerData.baseURl,this._consBatPlayerData.MountsType));
         }
      }
      
      private function drawCharacter() : void
      {
         var layer:* = undefined;
         var picWidth:Number = Number(this._loaders[0].width);
         var picHeight:Number = Number(this._loaders[0].height);
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

