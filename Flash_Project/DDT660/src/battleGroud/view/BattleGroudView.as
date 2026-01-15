package battleGroud.view
{
   import battleGroud.BattleGroudManager;
   import battleGroud.data.BatlleData;
   import battleGroud.data.BattleUpdateData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BattleGroudView extends BaseAlerFrame
   {
      
      private var _back:Bitmap;
      
      private var _goodBack:Bitmap;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      private var _descripMc:MovieClip;
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _miliContent:Component;
      
      private var _miliIcon:Bitmap;
      
      private var _MiliIconList:Array = ["","battle.junxian.xinbingBig","battle.junxian.xiashiBig","battle.junxian.zhongshiBig","battle.junxian.shangshiBig","battle.junxian.shaoweiBig","battle.junxian.zhongweiBig","battle.junxian.shangweiBig","battle.junxian.shaoxiaoBig","battle.junxian.zhongxiaoBig","battle.junxian.shangxiaoBig","battle.junxian.shaojiangBig","battle.junxian.zhongjiangBig","battle.junxian.shangjiangBig","battle.junxian.cishuaiBig","battle.junxian.yuanshuaiBig","battle.junxian.dayuanshuaiBig"];
      
      public function BattleGroudView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("ddt.battleGroud"));
         _info.showSubmit = false;
         _info.showCancel = false;
         _info.moveEnable = false;
         this._back = ComponentFactory.Instance.creat("battle.ground");
         addToContent(this._back);
         this._goodBack = ComponentFactory.Instance.creat("battle.goodsContent");
         addToContent(this._goodBack);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt1");
         addToContent(this._txt1);
         this._miliContent = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.comp");
         this._miliContent.graphics.beginFill(0);
         this._miliContent.graphics.drawRect(0,0,100,20);
         this._miliContent.graphics.endFill();
         this._miliContent.alpha = 0;
         addToContent(this._miliContent);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt2");
         addToContent(this._txt2);
         this._txt3 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt3");
         addToContent(this._txt3);
         this._txt4 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt4");
         addToContent(this._txt4);
         this._descripMc = ComponentFactory.Instance.creat("battle.descriptMc");
         this._descripMc.x = -1;
         this._descripMc.y = -6;
         this._list = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.vBox");
         this._list.addChild(this._descripMc);
         var sp:Sprite = new Sprite();
         sp.width = 100;
         sp.height = 30;
         this._list.addChild(sp);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.scrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addToContent(this._panel);
         this.setTxt(BattleGroudManager.Instance.orderdata);
         SocketManager.Instance.out.battleGroundUpdata(2);
      }
      
      public function setTxt(data:BattleUpdateData) : void
      {
         this._txt2.text = String(data.totalPrestige);
         this._txt3.text = String(data.addDayPrestge) + "/" + String(data.fairBattleDayPrestige);
         if(data.rankings != 0)
         {
            this._txt1.text = String(data.rankings);
         }
         this.setMilitary(data.totalPrestige);
      }
      
      public function setRanks(str:String) : void
      {
         this._txt1.text = str;
      }
      
      private function setMilitary(num:int) : void
      {
         var tmpData:BatlleData = BattleGroudManager.Instance.getBattleDataByPrestige(num);
         var nextData:BatlleData = BattleGroudManager.Instance.getBattleDataByLevel(tmpData.Level + 1);
         this._txt4.text = tmpData.Name;
         this._miliContent.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.updataLeavl",nextData.Prestige - num);
         this.creatIcon(this._MiliIconList[tmpData.Level]);
      }
      
      private function creatIcon(url:String) : void
      {
         if(Boolean(this._miliIcon))
         {
            ObjectUtils.disposeObject(this._miliIcon);
            this._miliIcon = null;
         }
         this._miliIcon = ComponentFactory.Instance.creat(url);
         this._miliIcon.x = this._goodBack.x + (this._goodBack.width - this._miliIcon.width) / 2;
         this._miliIcon.y = this._goodBack.y + (this._goodBack.height - this._miliIcon.height) / 2;
         addToContent(this._miliIcon);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
         }
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         _info = null;
         if(!_container)
         {
            return;
         }
         while(Boolean(_container.numChildren))
         {
            ObjectUtils.disposeObject(_container.getChildAt(0));
         }
         super.dispose();
      }
   }
}

