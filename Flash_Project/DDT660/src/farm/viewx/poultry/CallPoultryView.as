package farm.viewx.poultry
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.modelx.FarmPoultryInfo;
   import flash.utils.Dictionary;
   
   public class CallPoultryView extends BaseAlerFrame
   {
      
      private var _titleBg:ScaleBitmapImage;
      
      private var _btnBg:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _poultryBox:ComboBox;
      
      public function CallPoultryView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var alertInfo:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         alertInfo.moveEnable = false;
         alertInfo.autoDispose = false;
         info = alertInfo;
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("farm.friendListTitleBg");
         PositionUtils.setPos(this._titleBg,"asset.farm.poultry.titlePos");
         addToContent(this._titleBg);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("farm.callPoultry.alertBg");
         addToContent(this._btnBg);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.farmShopPayPnlTitle");
         this._titleTxt.text = LanguageMgr.GetTranslation("farm.tree.callPoultry.titleText");
         PositionUtils.setPos(this._titleTxt,"asset.farm.poultry.titleTxtPos");
         addToContent(this._titleTxt);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("farm.text.farmShopPayPnlTitle");
         this._infoText.text = LanguageMgr.GetTranslation("farm.tree.callPoultry.infoText");
         PositionUtils.setPos(this._infoText,"asset.farm.poultry.infoTextPos");
         addToContent(this._infoText);
         this._poultryBox = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.callView.poultryMenu");
         addToContent(this._poultryBox);
         this.addPoultryName();
      }
      
      private function addPoultryName() : void
      {
         var item:FarmPoultryInfo = null;
         var comboxModel:VectorListModel = this._poultryBox.listPanel.vectorListModel;
         comboxModel.clear();
         var level:int = FarmModelController.instance.model.FarmTreeLevel;
         var farmPoultryInfo:Dictionary = FarmModelController.instance.model.farmPoultryInfo;
         if(level > 0)
         {
            for each(item in farmPoultryInfo)
            {
               if(item.Level % 10 == 1 && item.Level <= level)
               {
                  comboxModel.append(item.MonsterName);
               }
            }
         }
         else
         {
            comboxModel.append(farmPoultryInfo[level].MonsterName);
         }
         this._poultryBox.textField.text = comboxModel.first();
         this._poultryBox.currentSelectedIndex = 0;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__closeFarmHelper);
         this._poultryBox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
      }
      
      protected function __onListClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __closeFarmHelper(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.callFarmPoultry(this._poultryBox.currentSelectedIndex * 10 + 1);
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__closeFarmHelper);
         this._poultryBox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._titleBg))
         {
            this._titleBg.dispose();
            this._titleBg = null;
         }
         if(Boolean(this._btnBg))
         {
            this._btnBg.dispose();
            this._btnBg = null;
         }
         if(Boolean(this._titleTxt))
         {
            this._titleTxt.dispose();
            this._titleTxt = null;
         }
         if(Boolean(this._infoText))
         {
            this._infoText.dispose();
            this._infoText = null;
         }
         if(Boolean(this._poultryBox))
         {
            this._poultryBox.dispose();
            this._poultryBox = null;
         }
         super.dispose();
      }
   }
}

