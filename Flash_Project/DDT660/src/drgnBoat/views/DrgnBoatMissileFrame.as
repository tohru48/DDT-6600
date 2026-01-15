package drgnBoat.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import drgnBoat.components.DrgnBoatNameCell;
   import drgnBoat.data.DrgnBoatPlayerInfo;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class DrgnBoatMissileFrame extends Frame
   {
      
      private var _labelBg:Bitmap;
      
      private var _labelTxt:FilterFrameText;
      
      private var _listBg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _submitBtn:TextButton;
      
      private var _list:Array;
      
      private var _playerList:Vector.<DrgnBoatPlayerInfo>;
      
      private var _threeBtnView:DrgnBoatThreeBtnView;
      
      public function DrgnBoatMissileFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         escEnable = true;
         enterEnable = true;
         this._labelBg = ComponentFactory.Instance.creat("drgnBoat.missile.labelBg");
         addToContent(this._labelBg);
         this._listBg = ComponentFactory.Instance.creat("drgnBoat.missile.listBg");
         addToContent(this._listBg);
         titleText = LanguageMgr.GetTranslation("drgnBoat.select");
         this._labelTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.missileFrame.labelTxt");
         this._labelTxt.text = LanguageMgr.GetTranslation("drgnBoat.selectTarget");
         addToContent(this._labelTxt);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.missileFrame.vbox");
         addToContent(this._vbox);
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         PositionUtils.setPos(this._submitBtn,"drgnBoat.missileFrame.btnPos");
         this._submitBtn.text = LanguageMgr.GetTranslation("drgnBoat.sendMissile");
         addToContent(this._submitBtn);
         this.setList();
      }
      
      private function setList() : void
      {
         var info:DrgnBoatPlayerInfo = null;
         var cell:DrgnBoatNameCell = null;
         this._playerList = DrgnBoatManager.instance.playerList;
         this._list = [];
         for(var i:int = 0; i <= this._playerList.length - 1; i++)
         {
            info = this._playerList[i] as DrgnBoatPlayerInfo;
            if(!info.isSelf)
            {
               cell = new DrgnBoatNameCell(i);
               cell.setData(info.name);
               cell.addEventListener(MouseEvent.CLICK,this.__cellClick);
               cell.buttonMode = true;
               this._vbox.addChild(cell);
               this._list.push(cell);
            }
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
      }
      
      protected function __cellClick(event:MouseEvent) : void
      {
         var cell:DrgnBoatNameCell = null;
         for each(cell in this._list)
         {
            cell.selected = false;
         }
         (event.currentTarget as DrgnBoatNameCell).selected = true;
      }
      
      protected function __submitBtnClick(event:MouseEvent) : void
      {
         var cell:DrgnBoatNameCell = null;
         for each(cell in this._list)
         {
            if(cell.selected == true)
            {
               this._threeBtnView.targetId = this._playerList[cell.index].id;
               this._threeBtnView.targetZone = this._playerList[cell.index].zoneId;
               this._threeBtnView.useSkill();
            }
         }
         this.dispose();
      }
      
      public function setThreeBtnView(view:DrgnBoatThreeBtnView) : void
      {
         this._threeBtnView = view;
      }
      
      protected function _response(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this.__submitBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._labelBg);
         this._labelBg = null;
         ObjectUtils.disposeObject(this._labelTxt);
         this._labelTxt = null;
         ObjectUtils.disposeObject(this._listBg);
         this._listBg = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._submitBtn);
         this._submitBtn = null;
         super.dispose();
      }
   }
}

