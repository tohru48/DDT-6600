package ddt.view.buff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.buff.buffButton.BuffButton;
   import ddt.view.buff.buffButton.GrowHelpBuffButton;
   import ddt.view.buff.buffButton.LabyrinthBuffButton;
   import ddt.view.buff.buffButton.PayBuffButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import oldplayergetticket.GetTicketEvent;
   import oldplayergetticket.GetTicketManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class BuffControl extends Sprite implements Disposeable
   {
      
      private var _buffData:DictionaryData;
      
      private var _buffList:HBox;
      
      private var _buffBtnArr:Array;
      
      private var _str:String;
      
      private var _spacing:int;
      
      private var _growHelpBuff:GrowHelpBuffButton;
      
      private var _payBuff:PayBuffButton;
      
      private var _labyrinthBuff:LabyrinthBuffButton;
      
      private var _expBlessedIcon:ScaleFrameImage;
      
      private var _getTicketBtn:BaseButton;
      
      public function BuffControl(str:String = "", spacing:int = 0)
      {
         super();
         this._spacing = spacing;
         this._str = str;
         this.init();
         this.initEvents();
      }
      
      public static function isPayBuff(buffInfo:BuffInfo) : Boolean
      {
         switch(buffInfo.Type)
         {
            case BuffInfo.Caddy_Good:
            case BuffInfo.Save_Life:
            case BuffInfo.Agility:
            case BuffInfo.ReHealth:
            case BuffInfo.Train_Good:
            case BuffInfo.Level_Try:
            case BuffInfo.Card_Get:
               return true;
            default:
               return false;
         }
      }
      
      private function init() : void
      {
         this._buffData = PlayerManager.Instance.Self.buffInfo;
         this._buffList = new HBox();
         this._buffList.spacing = this._spacing;
         addChild(this._buffList);
         this.initBuffButtons();
      }
      
      public function set boxSpacing(value:int) : void
      {
         this._buffList.spacing = value;
      }
      
      private function initEvents() : void
      {
         this._buffData.addEventListener(DictionaryEvent.ADD,this.__addBuff);
         this._buffData.addEventListener(DictionaryEvent.REMOVE,this.__removeBuff);
         this._buffData.addEventListener(DictionaryEvent.UPDATE,this.__addBuff);
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._buffData))
         {
            this._buffData.removeEventListener(DictionaryEvent.ADD,this.__addBuff);
            this._buffData.removeEventListener(DictionaryEvent.REMOVE,this.__removeBuff);
            this._buffData.removeEventListener(DictionaryEvent.UPDATE,this.__addBuff);
         }
      }
      
      private function initBuffButtons() : void
      {
         this.addGrowHelpIcon();
         this.addpayBuffIcon();
         this.setInfo(this._buffData);
         this._growHelpBuff.buffArray = this._buffBtnArr;
         this.addLabyrinthBuff();
         this.addExpBuff();
         this.addRegressTicketBuff();
      }
      
      private function addRegressTicketBuff() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_GET_TICKET,this.__addGetTicketBtn);
         SocketManager.Instance.out.sendRegressTicketInfo();
      }
      
      private function __addGetTicketBtn(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var evt:GetTicketEvent = new GetTicketEvent(GetTicketEvent.GETTICKET_DATA);
         evt.money = pkg.readInt();
         evt.level = pkg.readInt();
         evt.levelMoney = pkg.readInt();
         GetTicketManager.instance.dispatchEvent(evt);
         this.addOldPlayerGetTicketBtn();
      }
      
      private function addOldPlayerGetTicketBtn() : void
      {
         if(!this._getTicketBtn)
         {
            this._getTicketBtn = ComponentFactory.Instance.creatComponentByStylename("hall.getTicketButton");
            this._getTicketBtn.addEventListener(MouseEvent.CLICK,this.__onGetTicketClick);
         }
         this._buffList.addChild(this._getTicketBtn);
      }
      
      protected function __onGetTicketClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         GetTicketManager.instance.show();
      }
      
      private function addExpBuff() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_EXPBLESSED_DATA,this.__addExpBlessedBtn);
         SocketManager.Instance.out.sendExpBlessedData();
      }
      
      protected function __addExpBlessedBtn(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var expValue:int = pkg.readInt();
         if(expValue != 0)
         {
            if(!this._expBlessedIcon)
            {
               this._expBlessedIcon = ComponentFactory.Instance.creatComponentByStylename("hall.expblessed.icon");
            }
            this._expBlessedIcon.tipData = LanguageMgr.GetTranslation("ddt.HallStateView.expValue",expValue);
            this._buffList.addChild(this._expBlessedIcon);
         }
      }
      
      private function addGrowHelpIcon() : void
      {
         var item:BuffButton = null;
         this._growHelpBuff = new GrowHelpBuffButton();
         this._buffList.addChild(this._growHelpBuff);
         this._buffBtnArr = [];
         for(var i:int = 0; i < 4; i++)
         {
            item = BuffButton.createBuffButton(i);
            this._buffBtnArr.push(item);
         }
      }
      
      private function addpayBuffIcon() : void
      {
         this._payBuff = new PayBuffButton();
         this._payBuff.CanClick = false;
         this._buffList.addChild(this._payBuff);
      }
      
      private function addLabyrinthBuff() : void
      {
         var j:String = null;
         this._growHelpBuff.buffArray = this._buffBtnArr;
         for(j in this._buffData)
         {
            if(this._buffData[j] != null)
            {
               if(this._buffData[j].Type >= 74 && this._buffData[j].Type <= 80)
               {
                  if(!this._labyrinthBuff)
                  {
                     this._labyrinthBuff = new LabyrinthBuffButton();
                     this._buffList.addChild(this._labyrinthBuff);
                     break;
                  }
               }
            }
         }
      }
      
      public function setInfo(buffData:DictionaryData) : void
      {
         var j:String = null;
         for(j in buffData)
         {
            if(buffData[j] == null)
            {
               continue;
            }
            switch(buffData[j].Type)
            {
               case BuffInfo.DOUBEL_EXP:
                  this._buffBtnArr[0].info = buffData[j];
                  break;
               case BuffInfo.DOUBLE_GESTE:
                  this._buffBtnArr[1].info = buffData[j];
                  break;
               case BuffInfo.DOUBLE_PRESTIGE:
                  this._buffBtnArr[2].info = buffData[j];
                  break;
               case BuffInfo.DOUBLE_CONTRIBUTE:
                  this._buffBtnArr[3].info = buffData[j];
                  break;
               case BuffInfo.Caddy_Good:
               case BuffInfo.Save_Life:
               case BuffInfo.Agility:
               case BuffInfo.ReHealth:
               case BuffInfo.Train_Good:
               case BuffInfo.Level_Try:
               case BuffInfo.Card_Get:
                  this._payBuff.addBuff(buffData[j]);
                  break;
            }
         }
      }
      
      private function __addBuff(evt:DictionaryEvent) : void
      {
         var buffInfo:BuffInfo = evt.data as BuffInfo;
         switch(buffInfo.Type)
         {
            case BuffInfo.DOUBEL_EXP:
               this.setBuffButtonInfo(0,buffInfo);
               break;
            case BuffInfo.DOUBLE_GESTE:
               this.setBuffButtonInfo(1,buffInfo);
               break;
            case BuffInfo.DOUBLE_PRESTIGE:
               this.setBuffButtonInfo(2,buffInfo);
               break;
            case BuffInfo.DOUBLE_CONTRIBUTE:
               this.setBuffButtonInfo(3,buffInfo);
               break;
            case BuffInfo.Caddy_Good:
            case BuffInfo.Save_Life:
            case BuffInfo.Agility:
            case BuffInfo.ReHealth:
            case BuffInfo.Train_Good:
            case BuffInfo.Level_Try:
            case BuffInfo.Card_Get:
               this._payBuff.addBuff(buffInfo);
               break;
            case BuffInfo.PropertyWater_74:
            case BuffInfo.PropertyWater_74 + 1:
            case BuffInfo.PropertyWater_74 + 2:
            case BuffInfo.PropertyWater_74 + 3:
            case BuffInfo.PropertyWater_74 + 4:
            case BuffInfo.PropertyWater_74 + 5:
            case BuffInfo.PropertyWater_74 + 6:
               if(!this._labyrinthBuff)
               {
                  this._labyrinthBuff = new LabyrinthBuffButton();
                  this._buffList.addChild(this._labyrinthBuff);
               }
         }
      }
      
      private function setBuffButtonInfo(btnId:int, buffinfo:BuffInfo) : void
      {
         if(buffinfo.IsExist)
         {
            this._buffBtnArr[btnId].info = buffinfo;
         }
         else
         {
            this._buffBtnArr[btnId].isExist = false;
         }
      }
      
      private function __removeBuff(evt:DictionaryEvent) : void
      {
         switch((evt.data as BuffInfo).Type)
         {
            case BuffInfo.DOUBEL_EXP:
               this._buffBtnArr[0].info = new BuffInfo(BuffInfo.DOUBEL_EXP);
               break;
            case BuffInfo.DOUBLE_GESTE:
               this._buffBtnArr[1].info = new BuffInfo(BuffInfo.DOUBLE_GESTE);
               break;
            case BuffInfo.DOUBLE_PRESTIGE:
               this._buffBtnArr[2].info = new BuffInfo(BuffInfo.DOUBLE_PRESTIGE);
               break;
            case BuffInfo.DOUBLE_CONTRIBUTE:
               this._buffBtnArr[3].info = new BuffInfo(BuffInfo.DOUBLE_CONTRIBUTE);
         }
      }
      
      private function __updateBuff(evt:DictionaryEvent) : void
      {
      }
      
      public function set CanClick(value:Boolean) : void
      {
         var i:BuffButton = null;
         for each(i in this._buffBtnArr)
         {
            i.CanClick = value;
         }
      }
      
      private function deleteGetTicketBtn() : void
      {
         if(Boolean(this._getTicketBtn))
         {
            this._getTicketBtn.removeEventListener(MouseEvent.CLICK,this.__onGetTicketClick);
            this._getTicketBtn.dispose();
            this._getTicketBtn = null;
         }
      }
      
      private function deleteExpBlessedBtn() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_EXPBLESSED_DATA,this.__addExpBlessedBtn);
         if(Boolean(this._expBlessedIcon))
         {
            this._expBlessedIcon.dispose();
            this._expBlessedIcon = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._growHelpBuff))
         {
            this._growHelpBuff.dispose();
            this._growHelpBuff = null;
         }
         if(Boolean(this._labyrinthBuff))
         {
            this._labyrinthBuff.dispose();
            this._labyrinthBuff = null;
         }
         if(Boolean(this._buffList))
         {
            ObjectUtils.disposeObject(this._buffList);
            this._buffList = null;
         }
         this._buffData = null;
         this._buffBtnArr = null;
         this.deleteExpBlessedBtn();
         this.deleteGetTicketBtn();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get buffBtnArr() : Array
      {
         return this._buffBtnArr;
      }
   }
}

