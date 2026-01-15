package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class QuestInfoItemView extends Sprite implements Disposeable
   {
      
      protected var _titleBg:Bitmap;
      
      protected var _titleImg:ScaleFrameImage;
      
      protected var _content:Sprite;
      
      protected var _panel:ScrollPanel;
      
      protected var _info:QuestInfo;
      
      public function QuestInfoItemView()
      {
         super();
         this.initView();
      }
      
      override public function get height() : Number
      {
         return this._panel.y + Math.min(this._content.height,this._panel.height);
      }
      
      protected function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.quest.questinfoItemTitle");
         addChild(this._titleBg);
         this._content = new Sprite();
         this._panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestInfoItem.scrollPanel");
         this._panel.setView(this._content);
         addChild(this._panel);
      }
      
      public function set info(value:QuestInfo) : void
      {
         this._info = value;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeAllChildren(this._content);
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._titleImg))
         {
            this._titleImg.dispose();
            this._titleImg = null;
         }
      }
   }
}

