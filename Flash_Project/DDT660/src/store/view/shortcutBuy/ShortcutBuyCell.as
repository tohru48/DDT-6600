package store.view.shortcutBuy
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class ShortcutBuyCell extends BaseCell
   {
      
      private var _selected:Boolean = false;
      
      private var _mcBg:ScaleFrameImage;
      
      private var _lightEffect:Scale9CornerImage;
      
      private var _nameArr:Array = [LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.lingju"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.jiezi"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.shouzhuo"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baozhu"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.zhuque"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.xuanwu"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.qinglong"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baihu")];
      
      private var _shiner:ShineObject;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _shortcutText:FilterFrameText;
      
      private var _shortcutTextBg:ScaleBitmapImage;
      
      public function ShortcutBuyCell(info:ItemTemplateInfo)
      {
         var bg:Sprite = new Sprite();
         bg.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG"));
         super(bg);
         tipDirctions = "7,0";
         this._itemInfo = info;
         this.initII();
      }
      
      private function initII() : void
      {
         var name:String = null;
         var i:int = 0;
         this._mcBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.ShortcutCellBg");
         this._lightEffect = ComponentFactory.Instance.creatComponentByStylename("asset.ddtstore.CellBgSelectEffect");
         this._lightEffect.visible = false;
         this._mcBg.setFrame(1);
         addChildAt(this._mcBg,0);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.ddtstore.cellShine"));
         this._shiner.mouseChildren = this._shiner.mouseEnabled = this._shiner.visible = false;
         addChildAt(this._shiner,1);
         this._shortcutTextBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.ShortcutTextBg");
         addChild(this._shortcutTextBg);
         this._shortcutText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame.ShortcutText");
         this._shortcutText.mouseEnabled = false;
         if(EquipType.isComposeStone(this._itemInfo))
         {
            this._shortcutText.text = LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.Stone" + this._itemInfo.Property3);
         }
         else if(EquipType.isBeadNeedOpen(this._itemInfo))
         {
            this._shortcutText.text = this._itemInfo.Name;
            this._shortcutText.x = 4;
            this._shortcutText.y = 69;
            this._shortcutTextBg.width = 70;
         }
         else
         {
            name = "";
            for(i = 0; i < this._nameArr.length; i++)
            {
               if(this._itemInfo.Name.indexOf(this._nameArr[i]) > 0)
               {
                  name = this._nameArr[i];
                  break;
               }
            }
            this._shortcutText.text = name;
         }
         this._shortcutTextBg.x = this._shortcutText.x - 9;
         addChild(this._shortcutText);
         if(this._shortcutText.text == "")
         {
            this._lightEffect.x = this._mcBg.x = -3;
            this._lightEffect.y = this._mcBg.y = -3;
         }
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         if(Boolean(this._lightEffect))
         {
            addChild(this._lightEffect);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this._lightEffect.visible = this._selected;
      }
      
      public function startShine() : void
      {
         this._shiner.visible = true;
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
         this._shiner.visible = false;
      }
      
      public function showBg() : void
      {
         this._mcBg.visible = true;
      }
      
      public function hideBg() : void
      {
         this._mcBg.visible = false;
         this._lightEffect.visible = false;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._shortcutText))
         {
            ObjectUtils.disposeObject(this._shortcutText);
         }
         this._shortcutText = null;
         if(Boolean(this._shiner))
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(Boolean(this._mcBg))
         {
            ObjectUtils.disposeObject(this._mcBg);
         }
         this._mcBg = null;
         if(Boolean(this._lightEffect))
         {
            ObjectUtils.disposeObject(this._lightEffect);
         }
         this._lightEffect = null;
         this._itemInfo = null;
         this._nameArr = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

