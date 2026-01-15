package GodSyah
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import wonderfulActivity.views.IRightView;
   
   public class SyahView extends Sprite implements IRightView
   {
      
      private var _bg:Bitmap;
      
      private var _valid:FilterFrameText;
      
      private var _description:FilterFrameText;
      
      private var _content:SyahItemContent;
      
      private var _vbox:VBox;
      
      private var _scrollpanel:ScrollPanel;
      
      public function SyahView()
      {
         super();
         SyahManager.Instance.selectFromBagAndInfo();
         SyahManager.Instance.inView = true;
         this._buildUI();
      }
      
      private function _buildUI() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderfulactivity.GodSyah.syahView.bg");
         this._valid = ComponentFactory.Instance.creatComponentByStylename("wonderful.Activity.Syahview.validTxt");
         this._description = ComponentFactory.Instance.creatComponentByStylename("wonderful.Activity.Syahview.descriptionTxt");
         this._valid.text = SyahManager.Instance.valid;
         this._description.text = "        " + SyahManager.Instance.description;
         this._content = ComponentFactory.Instance.creatCustomObject("godsyah.syahview.syahitemcontent");
         addChild(this._bg);
         addChild(this._valid);
         addChild(this._description);
         this._createItem();
         addChild(this._content);
      }
      
      private function _createItem() : void
      {
         var item:SyahItem = null;
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("godsyah.syahview.syahitemVbox");
         var infos:Vector.<InventoryItemInfo> = SyahManager.Instance.cellItems;
         for(var i:int = 0; i < infos.length; i++)
         {
            item = ComponentFactory.Instance.creatCustomObject("godsyah.syahview.syahitem");
            item.setSyahItemInfo(infos[i]);
            this._vbox.addChild(item);
         }
         this._scrollpanel = ComponentFactory.Instance.creatComponentByStylename("godsyah.syahview.syahitemList");
         this._scrollpanel.setView(this._vbox);
         this._scrollpanel.invalidateViewport();
         addChild(this._scrollpanel);
      }
      
      public function init() : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function dispose() : void
      {
         SyahManager.Instance.inView = false;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._valid))
         {
            ObjectUtils.disposeObject(this._valid);
            this._valid = null;
         }
         if(Boolean(this._description))
         {
            ObjectUtils.disposeObject(this._description);
            this._description = null;
         }
         if(Boolean(this._content))
         {
            this._content.dispose();
            this._content = null;
         }
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
         }
         if(Boolean(this._scrollpanel))
         {
            ObjectUtils.disposeObject(this._scrollpanel);
            this._scrollpanel = null;
         }
      }
   }
}

