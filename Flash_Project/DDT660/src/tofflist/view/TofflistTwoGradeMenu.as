package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistTwoGradeMenu extends HBox implements Disposeable
   {
      
      public static const ACHIEVEMENTPOINT:String = "achievementpoint";
      
      public static const ASSETS:String = "assets";
      
      public static const BATTLE:String = "battle";
      
      public static const GESTE:String = "geste";
      
      public static const LEVEL:String = "level";
      
      public static const CHARM:String = "charm";
      
      public static const MATCHES:String = "matches";
      
      public static const MOUNTS:String = "mounts";
      
      private static const BTN_CONST:Array = [BATTLE,LEVEL,ASSETS,CHARM,MATCHES,MOUNTS];
      
      private var _battleBtn:SelectedTextButton;
      
      private var _assetsBtn:SelectedTextButton;
      
      private var _levelBtn:SelectedTextButton;
      
      private var _achiveBtn:SelectedTextButton;
      
      private var _charmBtn:SelectedTextButton;
      
      private var _matcheBtn:SelectedTextButton;
      
      private var _mountsBtn:SelectedTextButton;
      
      private var _btns:Array;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      public function TofflistTwoGradeMenu()
      {
         super();
         this._btns = [];
         this.initView();
      }
      
      private function initView() : void
      {
         var btn:SelectedTextButton = null;
         this._battleBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.battleBtn");
         this._levelBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.gradeOrderBtn");
         this._assetsBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.assetBtn");
         this._charmBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.charmvalueBtn");
         this._matcheBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.mathesBtn");
         this._mountsBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.mountsBtn");
         this._battleBtn.text = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
         this._levelBtn.text = LanguageMgr.GetTranslation("tank.menu.LevelTxt");
         this._assetsBtn.text = LanguageMgr.GetTranslation("consortia.Money");
         this._charmBtn.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
         this._matcheBtn.text = LanguageMgr.GetTranslation("tank.menu.battleGround");
         this._mountsBtn.text = LanguageMgr.GetTranslation("tank.menu.mounts");
         this._btns.push(this._battleBtn);
         this._btns.push(this._levelBtn);
         this._btns.push(this._assetsBtn);
         this._btns.push(this._charmBtn);
         this._btns.push(this._matcheBtn);
         this._btns.push(this._mountsBtn);
         addChild(this._battleBtn);
         addChild(this._levelBtn);
         addChild(this._assetsBtn);
         addChild(this._charmBtn);
         addChild(this._matcheBtn);
         addChild(this._mountsBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._battleBtn);
         this._selectedButtonGroup.addSelectItem(this._levelBtn);
         this._selectedButtonGroup.addSelectItem(this._assetsBtn);
         this._selectedButtonGroup.addSelectItem(this._charmBtn);
         this._selectedButtonGroup.addSelectItem(this._matcheBtn);
         this._selectedButtonGroup.addSelectItem(this._mountsBtn);
         this._selectedButtonGroup.selectIndex = 0;
         for each(btn in this._btns)
         {
            btn.addEventListener(MouseEvent.CLICK,this.__selectToolBarHandler);
         }
      }
      
      override public function dispose() : void
      {
         var btn:SelectedTextButton = null;
         for each(btn in this._btns)
         {
            btn.dispose();
            btn.removeEventListener(MouseEvent.CLICK,this.__selectToolBarHandler);
         }
         if(Boolean(this._battleBtn))
         {
            ObjectUtils.disposeObject(this._battleBtn);
         }
         if(Boolean(this._levelBtn))
         {
            ObjectUtils.disposeObject(this._levelBtn);
         }
         if(Boolean(this._assetsBtn))
         {
            ObjectUtils.disposeObject(this._assetsBtn);
         }
         if(Boolean(this._charmBtn))
         {
            ObjectUtils.disposeObject(this._charmBtn);
         }
         if(Boolean(this._matcheBtn))
         {
            ObjectUtils.disposeObject(this._matcheBtn);
         }
         if(Boolean(this._mountsBtn))
         {
            ObjectUtils.disposeObject(this._mountsBtn);
         }
         this._battleBtn = null;
         this._levelBtn = null;
         this._assetsBtn = null;
         this._charmBtn = null;
         this._matcheBtn = null;
         this._mountsBtn = null;
         this._btns = null;
         super.dispose();
      }
      
      public function setParentType(parentType:String) : void
      {
         var btn:SelectedTextButton = null;
         this.type = BATTLE;
         for each(btn in this._btns)
         {
            if(Boolean(btn.parent))
            {
               btn.parent.removeChild(btn);
            }
         }
         if(parentType == TofflistStairMenu.PERSONAL)
         {
            addChild(this._battleBtn);
            addChild(this._levelBtn);
            addChild(this._charmBtn);
            addChild(this._matcheBtn);
            addChild(this._mountsBtn);
         }
         else if(parentType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
         {
            addChild(this._battleBtn);
            addChild(this._levelBtn);
            addChild(this._charmBtn);
            addChild(this._mountsBtn);
         }
         else if(parentType == TofflistStairMenu.CONSORTIA || parentType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
         {
            addChild(this._battleBtn);
            addChild(this._levelBtn);
            addChild(this._assetsBtn);
            addChild(this._charmBtn);
         }
         for each(btn in this._btns)
         {
            btn.selected = false;
         }
         this._selectedButtonGroup.selectIndex = 0;
      }
      
      public function get type() : String
      {
         return TofflistModel.secondMenuType;
      }
      
      public function set type(value:String) : void
      {
         TofflistModel.secondMenuType = value;
         dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.type));
      }
      
      private function __selectToolBarHandler(event:MouseEvent) : void
      {
         if(this.type == event.currentTarget.name)
         {
            return;
         }
         SoundManager.instance.play("008");
         this.type = BTN_CONST[this._btns.indexOf(event.currentTarget)];
      }
   }
}

