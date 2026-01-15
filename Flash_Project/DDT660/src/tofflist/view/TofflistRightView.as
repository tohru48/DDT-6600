package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import tofflist.TofflistController;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistRightView extends Sprite implements Disposeable
   {
      
      private var _contro:TofflistController;
      
      private var _currentData:Array;
      
      private var _currentPage:int;
      
      private var _gridBox:TofflistGridBox;
      
      private var _pageTxt:FilterFrameText;
      
      private var _pgdn:BaseButton;
      
      private var _pgup:BaseButton;
      
      private var _stairMenu:TofflistStairMenu;
      
      private var _thirdClassMenu:TofflistThirdClassMenu;
      
      private var _totalPage:int;
      
      private var _twoGradeMenu:TofflistTwoGradeMenu;
      
      private var _leftInfo:TofflistLeftInfoView;
      
      private var _upDownTextBg:Image;
      
      private var _bg:MutipleImage;
      
      public function TofflistRightView($contro:TofflistController)
      {
         this._contro = $contro;
         super();
         this.init();
         this.addEvent();
      }
      
      public function get gridBox() : TofflistGridBox
      {
         return this._gridBox;
      }
      
      public function dispose() : void
      {
         this._contro = null;
         this._currentData = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(Boolean(this._gridBox))
         {
            ObjectUtils.disposeObject(this._gridBox);
         }
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
         }
         if(Boolean(this._pgdn))
         {
            ObjectUtils.disposeObject(this._pgdn);
         }
         if(Boolean(this._pgup))
         {
            ObjectUtils.disposeObject(this._pgup);
         }
         if(Boolean(this._upDownTextBg))
         {
            ObjectUtils.disposeObject(this._upDownTextBg);
         }
         if(Boolean(this._stairMenu))
         {
            ObjectUtils.disposeObject(this._stairMenu);
         }
         if(Boolean(this._twoGradeMenu))
         {
            ObjectUtils.disposeObject(this._twoGradeMenu);
         }
         if(Boolean(this._thirdClassMenu))
         {
            ObjectUtils.disposeObject(this._thirdClassMenu);
         }
         if(Boolean(this._leftInfo))
         {
            ObjectUtils.disposeObject(this._leftInfo);
         }
         this._bg = null;
         this._gridBox = null;
         this._pageTxt = null;
         this._pgdn = null;
         this._pgup = null;
         this._upDownTextBg = null;
         this._stairMenu = null;
         this._twoGradeMenu = null;
         this._thirdClassMenu = null;
         this._leftInfo = null;
      }
      
      public function updateTime(timeStr:String) : void
      {
         if(Boolean(timeStr))
         {
            this._leftInfo.updateTimeTxt.text = LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + "  " + timeStr;
         }
         else
         {
            this._leftInfo.updateTimeTxt.text = "";
         }
      }
      
      public function get firstType() : String
      {
         return this._stairMenu.type;
      }
      
      public function orderList($list:Array) : void
      {
         if(!$list)
         {
            return;
         }
         this._currentData = $list;
         this._gridBox.updateList($list);
         this._totalPage = Math.ceil(($list == null ? 0 : $list.length) / 8);
         if(Boolean(this._currentData) && this._currentData.length > 0)
         {
            this._currentPage = 1;
         }
         else
         {
            this._currentPage = 1;
         }
         this.checkPageBtn();
      }
      
      public function get twoGradeType() : String
      {
         return this._twoGradeMenu.type;
      }
      
      private function __addToStageHandler(evt:Event) : void
      {
         this._stairMenu.type = TofflistStairMenu.PERSONAL;
         this._twoGradeMenu.setParentType(this._stairMenu.type);
      }
      
      private function __menuTypeHandler(evt:TofflistEvent) : void
      {
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_BATTLE);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_LEVEL);
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_ACHIVE);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_CHARM);
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_MATCH);
                     break;
                  case TofflistTwoGradeMenu.MOUNTS:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_MOUNTS);
               }
               break;
            case TofflistStairMenu.CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_BATTLE);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_LEVEL);
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_ASSET);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_CHARM);
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_BATTLE);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_LEVEL);
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_ACHIVE);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_CHARM);
                     break;
                  case TofflistTwoGradeMenu.MOUNTS:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_MOUNTS);
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_BATTLE);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_LEVEL);
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_ASSET);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_CHARM);
               }
         }
      }
      
      private function __pgdnHandler(evt:MouseEvent) : void
      {
         if(!this._currentData)
         {
            return;
         }
         SoundManager.instance.play("008");
         ++this._currentPage;
         this._gridBox.updateList(this._currentData,this._currentPage);
         this.checkPageBtn();
      }
      
      private function __pgupHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this._currentPage;
         this._gridBox.updateList(this._currentData,this._currentPage);
         this.checkPageBtn();
      }
      
      private function __searchOrderHandler(evt:TofflistEvent) : void
      {
         var _type:String = null;
         this._contro.clearDisplayContent();
         if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
         {
            _type = "personal";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("personalBattleAccumulate","CelebByDayFightPowerList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("individualGradeDay","CelebByDayGPList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("individualGradeWeek","CelebByWeekGPList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("individualGradeAccumulate","CelebByGPList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("PersonalAchievementPointDay","CelebByAchievementPointDayList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("PersonalAchievementPointWeek","CelebByAchievementPointWeekList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("PersonalAchievementPoint","CelebByAchievementPointList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("PersonalCharmvalueDay","CelebByDayGiftGp.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("PersonalCharmvalueWeek","CelebByWeekGiftGp.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("PersonalCharmvalue","CelebByGiftGpList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.MATCHES)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("personalMatchesWeek","CelebByTotalPrestige.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.MOUNTS)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("personalMountsAccumulate","CelebByMountExpList.xml",_type);
               }
            }
         }
         else if(TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)
         {
            _type = "sociaty";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("consortiaBattleAccumulate","CelebByConsortiaFightPower.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("consortiaGradeAccumulate","CelebByConsortiaLevel.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("consortiaAssetDay","CelebByConsortiaDayRiches.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("consortiaAssetWeek","CelebByConsortiaWeekRiches.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("consortiaAssetAccumulate","CelebByConsortiaRiches.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("ConsortiaCharmvalueDay","CelebByConsortiaDayGiftGp.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("ConsortiaCharmvalueWeek","CelebByConsortiaWeekGiftGp.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("ConsortiaCharmvalue","CelebByConsortiaGiftGp.xml",_type);
               }
            }
         }
         else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
         {
            _type = "personal";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerPersonalBattleAccumulate","AreaCelebByDayFightPowerList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerIndividualGradeDay","AreaCelebByDayGPList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerIndividualGradeWeek","AreaCelebByWeekGPList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerIndividualGradeAccumulate","AreaCelebByGPList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerPersonalAchievementPointDay","AreaCelebByAchievementPointDayList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerPersonalAchievementPointWeek","AreaCelebByAchievementPointWeekList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerPersonalAchievementPoint","AreaCelebByAchievementPointList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerPersonalCharmvalueDay","AreaCelebByGiftGpDayList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerPersonalCharmvalueWeek","AreaCelebByGiftGpWeekList.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerPersonalCharmvalue","AreaCelebByGiftGpList.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.MOUNTS)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerIndividualMountsAccumulate","AreaCelebByMountExpList.xml",_type);
               }
            }
         }
         else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
         {
            _type = "sociaty";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaGradeAccumulate","AreaCelebByConsortiaLevel.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerConsortiaAssetDay","AreaCelebByConsortiaDayRiches.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerConsortiaAssetWeek","AreaCelebByConsortiaWeekRiches.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaAssetAccumulate","AreaCelebByConsortiaRiches.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaBattleAccumulate","AreaCelebByConsortiaFightPower.xml",_type);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerConsortiaCharmvalueDay","AreaCelebByConsortiaDayGiftGp.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerConsortiaCharmvalueWeek","AreaCelebByConsortiaWeekGiftGp.xml",_type);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaCharmvalue","AreaCelebByConsortiaGiftGp.xml",_type);
               }
            }
         }
      }
      
      private function __selectChildBarHandler(evt:TofflistEvent) : void
      {
         this._contro.clearDisplayContent();
         this._thirdClassMenu.selectType(this._stairMenu.type,TofflistModel.secondMenuType);
      }
      
      private function __selectStairMenuHandler(evt:TofflistEvent) : void
      {
         this._contro.clearDisplayContent();
         this._twoGradeMenu.setParentType(TofflistModel.firstMenuType);
      }
      
      private function addEvent() : void
      {
         this._thirdClassMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__searchOrderHandler);
         this._twoGradeMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectChildBarHandler);
         this._stairMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectStairMenuHandler);
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__menuTypeHandler);
         this._pgup.addEventListener(MouseEvent.CLICK,this.__pgupHandler);
         this._pgdn.addEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
      }
      
      private function checkPageBtn() : void
      {
         if(this._currentPage <= 1)
         {
            this._pgup.enable = false;
         }
         else
         {
            this._pgup.enable = true;
         }
         if(this._currentPage < this._totalPage)
         {
            this._pgdn.enable = true;
         }
         else
         {
            this._pgdn.enable = false;
         }
         this._pageTxt.text = this._currentPage + "/" + this._totalPage;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("toffilist.rightBg");
         addChild(this._bg);
         this._gridBox = ComponentFactory.Instance.creatCustomObject("tofflist.gridBox");
         addChild(this._gridBox);
         this._stairMenu = ComponentFactory.Instance.creatCustomObject("tofflist.stairMenu");
         addChild(this._stairMenu);
         this._twoGradeMenu = ComponentFactory.Instance.creatCustomObject("tofflist.twoGradeMenu");
         addChild(this._twoGradeMenu);
         this._thirdClassMenu = ComponentFactory.Instance.creatCustomObject("tofflist.hirdClassMenu");
         addChild(this._thirdClassMenu);
         this._pgup = ComponentFactory.Instance.creatComponentByStylename("toffilist.prePageBtn");
         addChild(this._pgup);
         this._pgdn = ComponentFactory.Instance.creatComponentByStylename("toffilist.nextPageBtn");
         addChild(this._pgdn);
         this._upDownTextBg = ComponentFactory.Instance.creat("asset.Toffilist.upDownTextBgImgAsset");
         addChild(this._upDownTextBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.pageTxt");
         addChild(this._pageTxt);
         this._leftInfo = ComponentFactory.Instance.creatCustomObject("tofflist.leftInfoView");
         addChild(this._leftInfo);
      }
      
      private function removeEvent() : void
      {
         this._stairMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectStairMenuHandler);
         this._twoGradeMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectChildBarHandler);
         this._thirdClassMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__searchOrderHandler);
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__menuTypeHandler);
         this._pgup.removeEventListener(MouseEvent.CLICK,this.__pgupHandler);
         this._pgdn.removeEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
      }
   }
}

