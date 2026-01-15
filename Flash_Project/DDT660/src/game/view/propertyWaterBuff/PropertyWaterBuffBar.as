package game.view.propertyWaterBuff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class PropertyWaterBuffBar extends Sprite implements Disposeable
   {
      
      private var _container:HBox;
      
      private var _buffList:DictionaryData;
      
      private var _iconList:Vector.<PropertyWaterBuffIcon>;
      
      public function PropertyWaterBuffBar()
      {
         super();
         this.init();
      }
      
      public static function getPropertyWaterBuffList(buffInfos:DictionaryData) : DictionaryData
      {
         var i:BuffInfo = null;
         var tempList:DictionaryData = new DictionaryData();
         for each(i in buffInfos)
         {
            if(EquipType.isPropertyWater(i.buffItemInfo))
            {
               tempList.add(i.Type,i);
            }
         }
         return tempList;
      }
      
      private function init() : void
      {
         this._container = UICreatShortcut.creatAndAdd("game.view.propertyWaterBuffBer",this);
         this._buffList = getPropertyWaterBuffList(PlayerManager.Instance.Self.buffInfo);
         this.createIconList();
      }
      
      private function createIconList() : void
      {
         var i:BuffInfo = null;
         var icon:PropertyWaterBuffIcon = null;
         this._iconList = new Vector.<PropertyWaterBuffIcon>();
         for each(i in this._buffList)
         {
            icon = ComponentFactory.Instance.creat("game.view.propertyWaterBuff.propertyWaterBuffIcon",[i]);
            this._iconList.push(icon);
            this._container.addChild(icon);
         }
      }
      
      private function disposeIconList() : void
      {
         var icon:PropertyWaterBuffIcon = null;
         for each(icon in this._iconList)
         {
            ObjectUtils.disposeObject(icon);
            icon = null;
         }
      }
      
      public function dispose() : void
      {
         this.disposeIconList();
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

