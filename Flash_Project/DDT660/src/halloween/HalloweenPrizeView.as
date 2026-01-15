package halloween
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class HalloweenPrizeView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _rank:FilterFrameText;
      
      private var _prize:FilterFrameText;
      
      private var vbox:VBox;
      
      public function HalloweenPrizeView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var hbox:HBox = null;
         var j:int = 0;
         var cellBg:Bitmap = null;
         var itemInfo:ItemTemplateInfo = null;
         var tInfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         this._bg = ComponentFactory.Instance.creat("asset.halloween.prize.bg");
         this._rank = ComponentFactory.Instance.creat("asset.halloween.titleName");
         this._prize = ComponentFactory.Instance.creat("asset.halloween.titleName");
         PositionUtils.setPos(this._rank,"asset.pos.title1");
         PositionUtils.setPos(this._prize,"asset.pos.title2");
         this._rank.text = LanguageMgr.GetTranslation("ddt.halloween.titleName1");
         this._prize.text = LanguageMgr.GetTranslation("ddt.halloween.titleName2");
         addChild(this._bg);
         this.vbox = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.prize.vbox");
         this.vbox.autoSize = 2;
         for(var i:int = 0; i < HalloweenManager.instance.prizeArr.length; i++)
         {
            hbox = new HBox();
            hbox.spacing = 5;
            hbox.autoSize = 2;
            for(j = 0; j < HalloweenManager.instance.prizeArr[i].length; j++)
            {
               cellBg = ComponentFactory.Instance.creatBitmap("asset.halloween.prize.cell");
               itemInfo = ItemManager.Instance.getTemplateById(HalloweenManager.instance.prizeArr[i][j].templateId) as ItemTemplateInfo;
               tInfo = new InventoryItemInfo();
               ObjectUtils.copyProperties(tInfo,itemInfo);
               tInfo.ValidDate = HalloweenManager.instance.prizeArr[i][j].validate;
               tInfo.StrengthenLevel = HalloweenManager.instance.prizeArr[i][j].strenthLevel;
               tInfo.AttackCompose = HalloweenManager.instance.prizeArr[i][j].attack;
               tInfo.DefendCompose = HalloweenManager.instance.prizeArr[i][j].defend;
               tInfo.LuckCompose = HalloweenManager.instance.prizeArr[i][j].luck;
               tInfo.AgilityCompose = HalloweenManager.instance.prizeArr[i][j].agility;
               tInfo.IsBinds = HalloweenManager.instance.prizeArr[i][j].isBind;
               cell = new BagCell(j,tInfo,false,cellBg);
               cell.setContentSize(35,35);
               cell.setCount(HalloweenManager.instance.prizeArr[i][j].count);
               hbox.addChild(cell);
            }
            this.vbox.addChild(hbox);
         }
         this.vbox.x = 167 + (218 - this.vbox.width) / 2;
         addChild(this.vbox);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._rank);
         }
         this._rank = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._prize);
         }
         this._prize = null;
      }
   }
}

