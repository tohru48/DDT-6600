package wantstrong.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import wantstrong.WantStrongManager;
   import wantstrong.data.WantStrongMenuData;
   
   public class WantStrongCell extends Sprite implements Disposeable
   {
      
      private var _info:Vector.<WantStrongMenuData> = new Vector.<WantStrongMenuData>();
      
      private var _bg:ScaleFrameImage;
      
      private var _selected:Boolean = false;
      
      private var _titlefield:FilterFrameText;
      
      private var _title:String;
      
      public function WantStrongCell(info:Vector.<WantStrongMenuData>, title:String)
      {
         super();
         this._info = info;
         this._title = title;
         buttonMode = true;
         this.initUI();
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
         DisplayUtils.setFrame(this._bg,this._selected ? 2 : 1);
         DisplayUtils.setFrame(this._titlefield,this._selected ? 2 : 1);
      }
      
      public function get info() : Vector.<WantStrongMenuData>
      {
         return this._info;
      }
      
      public function openItem() : void
      {
         SoundManager.instance.play("008");
         WantStrongManager.Instance.setCurrentInfo(this._info);
      }
      
      private function initUI() : void
      {
         if(this._title == LanguageMgr.GetTranslation("ddt.wantStrong.view.findBack"))
         {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("wantstrong.ActivitySpecialCellBg");
            this._titlefield = ComponentFactory.Instance.creatComponentByStylename("wantstrong.ActivitySpecailCellTitleText");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("wantstrong.ActivityCellBg");
            this._titlefield = ComponentFactory.Instance.creatComponentByStylename("wantstrong.ActivityCellTitleText");
         }
         DisplayUtils.setFrame(this._bg,this._selected ? 2 : 1);
         addChild(this._bg);
         this._titlefield.htmlText = "<b>·</b> " + this._title;
         addChild(this._titlefield);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titlefield);
         this._titlefield = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

