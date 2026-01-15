package consumeRank.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consumeRank.ConsumeRankManager;
   import consumeRank.data.ConsumeRankVo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import road7th.utils.DateUtils;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.views.IRightView;
   
   public class ConsumeRankView extends Sprite implements IRightView
   {
      
      private var _bg:Bitmap;
      
      private var _dateTxt:FilterFrameText;
      
      private var _checkTxt:FilterFrameText;
      
      private var _checkBg:ScaleBitmapImage;
      
      private var _outOfRankLabel:FilterFrameText;
      
      private var _myRankLabel:FilterFrameText;
      
      private var _rankLabelTxt:FilterFrameText;
      
      private var _rankTxtBg:Scale9CornerImage;
      
      private var _rankTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _myRank:int;
      
      private var refreshCount:int = 0;
      
      public function ConsumeRankView()
      {
         super();
      }
      
      public function init() : void
      {
         ConsumeRankManager.instance.view = this;
         this.initView();
         this.updateView();
         this.initTimer();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderfulactivity.conRank.bg");
         addChild(this._bg);
         this._dateTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.dateTxt");
         addChild(this._dateTxt);
         this._checkBg = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.checkBg");
         addChild(this._checkBg);
         this._checkBg.tipStyle = "ddt.view.tips.OneLineTip";
         this._checkBg.tipDirctions = "0";
         this._checkTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.checkTxt");
         addChild(this._checkTxt);
         this._checkTxt.text = LanguageMgr.GetTranslation("consumeRank.checkConsume");
         this._outOfRankLabel = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.labelTxt");
         addChild(this._outOfRankLabel);
         this._outOfRankLabel.text = LanguageMgr.GetTranslation("consumeRank.outOfRankLabel",100,6000);
         this._outOfRankLabel.visible = false;
         this._myRankLabel = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.myRankLabel");
         addChild(this._myRankLabel);
         this._myRankLabel.text = LanguageMgr.GetTranslation("consumeRank.myRank");
         this._rankLabelTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.labelTxt2");
         addChild(this._rankLabelTxt);
         this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.rankLabel",5000);
         this._rankTxtBg = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.rankBg");
         addChild(this._rankTxtBg);
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.rankTxt");
         addChild(this._rankTxt);
         this._rankTxt.text = "20";
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
      }
      
      public function updateView() : void
      {
         var myConsume:int = 0;
         var vo:ConsumeRankVo = null;
         var xmlData:GmActivityInfo = ConsumeRankManager.instance.xmlData;
         var beginDate:String = this.dateTrim(xmlData.beginTime);
         var endDate:String = this.dateTrim(xmlData.endTime);
         this._dateTxt.text = beginDate + "-" + endDate;
         this._checkBg.tipData = LanguageMgr.GetTranslation("consumeRank.helpTxt",xmlData.remain2);
         var arr:Array = ConsumeRankManager.instance.rankList;
         myConsume = ConsumeRankManager.instance.myConsume;
         this._myRank = -1;
         for(var i:int = 0; i <= arr.length - 1; i++)
         {
            vo = arr[i] as ConsumeRankVo;
            if(vo.userId == PlayerManager.Instance.Self.ID)
            {
               this._myRank = i;
               break;
            }
         }
         var remain:int = 0;
         if(this._myRank >= 0)
         {
            this._outOfRankLabel.visible = false;
            this._myRankLabel.visible = true;
            this._rankTxtBg.visible = true;
            this._rankTxt.visible = true;
            this._rankTxt.text = String(this._myRank + 1);
            if(this._myRank == 0)
            {
               this._rankLabelTxt.visible = false;
            }
            else
            {
               this._rankLabelTxt.visible = true;
               remain = (arr[this._myRank - 1] as ConsumeRankVo).consume - myConsume + 1;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.rankLabel",remain);
            }
            if(ConsumeRankManager.instance.status == 2)
            {
               this._rankLabelTxt.visible = true;
               this._rankLabelTxt.textColor = 16711680;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.over");
            }
         }
         else
         {
            this._myRankLabel.visible = false;
            this._rankTxtBg.visible = false;
            this._rankTxt.visible = false;
            this._rankLabelTxt.visible = true;
            this._outOfRankLabel.visible = true;
            if(arr.length > 0)
            {
               remain = (arr[arr.length - 1] as ConsumeRankVo).consume - myConsume + 1;
            }
            else
            {
               remain = 1;
            }
            this._outOfRankLabel.text = LanguageMgr.GetTranslation("consumeRank.outOfRank");
            this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.outOfRankLabel",myConsume,remain);
            if(ConsumeRankManager.instance.status == 2)
            {
               this._rankLabelTxt.visible = true;
               this._rankLabelTxt.textColor = 16711680;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.over");
            }
         }
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var item:ConsumeRankItem = null;
         var voArr:Array = ConsumeRankManager.instance.rankList;
         var giftArr:Array = ConsumeRankManager.instance.xmlData.giftbagArray;
         this._vbox.removeAllChild();
         for(var i:int = 0; i <= voArr.length - 1; i++)
         {
            item = new ConsumeRankItem(i);
            item.setData(voArr[i],giftArr[i]);
            this._vbox.addChild(item);
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function dateTrim(dateStr:String) : String
      {
         var str:String = "";
         var temp:Array = dateStr.split(" ");
         return temp[0] + " " + temp[1].slice(0,5);
      }
      
      private function initTimer() : void
      {
         WonderfulActivityManager.Instance.addTimerFun("consumeRank",this.consumeRankTimerHandler);
      }
      
      private function consumeRankTimerHandler() : void
      {
         var endDate:Date = DateUtils.getDateByStr(ConsumeRankManager.instance.xmlData.endTime);
         var nowDate:Date = TimeManager.Instance.Now();
         var diff:Number = Math.round((endDate.getTime() - nowDate.getTime()) / 1000);
         if(diff > 0)
         {
            ++this.refreshCount;
            if(diff >= 60 * 60)
            {
               if(this.refreshCount >= 5 * 60)
               {
                  this.refreshCount = 0;
                  SocketManager.Instance.out.updateConsumeRank();
               }
            }
            else if(this.refreshCount >= 30)
            {
               this.refreshCount = 0;
               SocketManager.Instance.out.updateConsumeRank();
            }
         }
         else
         {
            WonderfulActivityManager.Instance.delTimerFun("consumeRank");
         }
      }
      
      public function dispose() : void
      {
         ConsumeRankManager.instance.view = null;
         WonderfulActivityManager.Instance.delTimerFun("consumeRank");
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._dateTxt);
         this._dateTxt = null;
         ObjectUtils.disposeObject(this._checkTxt);
         this._checkTxt = null;
         ObjectUtils.disposeObject(this._checkBg);
         this._checkBg = null;
         ObjectUtils.disposeObject(this._outOfRankLabel);
         this._outOfRankLabel = null;
         ObjectUtils.disposeObject(this._rankLabelTxt);
         this._rankLabelTxt = null;
         ObjectUtils.disposeObject(this._rankTxt);
         this._rankTxt = null;
         ObjectUtils.disposeObject(this._rankTxtBg);
         this._rankTxtBg = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
   }
}

