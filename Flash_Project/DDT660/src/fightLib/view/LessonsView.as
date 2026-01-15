package fightLib.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import fightLib.LessonType;
   import fightLib.script.FightLibGuideScripit;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LessonsView extends Sprite implements Disposeable
   {
      
      private var _background:Bitmap;
      
      private var _defaultImg:Bitmap;
      
      private var _difficultyImg:Bitmap;
      
      private var _background2:MutipleImage;
      
      private var _background3:MutipleImage;
      
      private var _background4:MovieClip;
      
      private var _measureButton:LessonButton;
      
      private var _twentyButton:LessonButton;
      
      private var _sixtyFiveButton:LessonButton;
      
      private var _highThrowButton:LessonButton;
      
      private var _highGapButton:LessonButton;
      
      private var _lassButton:LessonButton;
      
      private var _levelGroup:SelectedButtonGroup;
      
      private var _lowButton:LevelButton;
      
      private var _mediumButton:LevelButton;
      
      private var _highButton:LevelButton;
      
      private var _startButton:MovieClip;
      
      private var _cancelButton:SimpleBitmapButton;
      
      private var _lessonType:int;
      
      private var _selectedLesson:LessonButton;
      
      private var _selectedLevel:LevelButton;
      
      private var _lessonButtons:Vector.<LessonButton> = new Vector.<LessonButton>();
      
      private var _levelButtons:Vector.<LevelButton> = new Vector.<LevelButton>();
      
      private var _sencondType:int = 3;
      
      private var _guildMovie:MovieClip;
      
      private var _awardView:FightLibAwardView;
      
      public function LessonsView()
      {
         super();
         this.configUI();
         this.addEvent();
         this.updateLessonButtonState();
         this.updateLevelButtonState();
      }
      
      private function configUI() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("fightLib.lesson.background");
         addChild(this._background);
         this._background2 = ComponentFactory.Instance.creatComponentByStylename("fightlib.lesson.awardBg");
         addChild(this._background2);
         this._background4 = ClassUtils.CreatInstance("fightLib.Award.bg");
         PositionUtils.setPos(this._background4,"fightLib.Award.bgPos");
         addChild(this._background4);
         this._defaultImg = ComponentFactory.Instance.creatBitmap("asset.fightlib.charecaterPng");
         addChild(this._defaultImg);
         this._background3 = ComponentFactory.Instance.creatComponentByStylename("fightLib.levelBtnAreaBg");
         addChild(this._background3);
         this._difficultyImg = ComponentFactory.Instance.creatBitmap("fightlib.asset.difficultyTitle");
         addChild(this._difficultyImg);
         this._measureButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.MeasureButton");
         this._measureButton.type = LessonType.Measure;
         this._lessonButtons.push(this._measureButton);
         addChild(this._measureButton);
         this._twentyButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.TwentyButton");
         this._twentyButton.type = LessonType.Twenty;
         this._lessonButtons.push(this._twentyButton);
         addChild(this._twentyButton);
         this._sixtyFiveButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.SixtyFiveButton");
         this._sixtyFiveButton.type = LessonType.SixtyFive;
         this._lessonButtons.push(this._sixtyFiveButton);
         addChild(this._sixtyFiveButton);
         this._highThrowButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.HighThrowButton");
         this._highThrowButton.type = LessonType.HighThrow;
         this._lessonButtons.push(this._highThrowButton);
         addChild(this._highThrowButton);
         this._highGapButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.HighGapButton");
         this._highGapButton.type = LessonType.HighGap;
         this._lessonButtons.push(this._highGapButton);
         addChild(this._highGapButton);
         this._lassButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.LassButton");
         addChild(this._lassButton);
         this._lowButton = ComponentFactory.Instance.creatCustomObject("fightLib.lesson.LowButton");
         addChild(this._lowButton);
         this._mediumButton = ComponentFactory.Instance.creatCustomObject("fightLib.lesson.MediumButton");
         addChild(this._mediumButton);
         this._highButton = ComponentFactory.Instance.creatCustomObject("fightLib.lesson.HighButton");
         addChild(this._highButton);
         this._levelButtons.push(this._lowButton);
         this._levelButtons.push(this._mediumButton);
         this._levelButtons.push(this._highButton);
         this._startButton = ClassUtils.CreatInstance("asset.ddtroom.startMovie");
         this._startButton.buttonMode = true;
         addChild(this._startButton);
         PositionUtils.setPos(this._startButton,"fightlib.startbtn.pos");
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("fightLib.Lessons.CancelButton");
         addChild(this._cancelButton);
         this._awardView = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibAwardView");
         addChild(this._awardView);
         this._guildMovie = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.GuildMovie");
         addChild(this._guildMovie);
         this.updateLessonButtonState();
         this.updateLevelButtonState();
      }
      
      private function updateLast() : void
      {
         this.unSelectedAllLesson();
         this.unselectedAllLevel();
         if(FightLibManager.Instance.lastInfo != null)
         {
            switch(FightLibManager.Instance.lastInfo.id)
            {
               case LessonType.Measure:
                  this.selectedLesson = this._measureButton;
                  break;
               case LessonType.Twenty:
                  this.selectedLesson = this._twentyButton;
                  break;
               case LessonType.SixtyFive:
                  this.selectedLesson = this._sixtyFiveButton;
                  break;
               case LessonType.HighThrow:
                  this.selectedLesson = this._highThrowButton;
                  break;
               case LessonType.HighGap:
                  this.selectedLesson = this._highGapButton;
                  break;
               default:
                  return;
            }
            switch(FightLibManager.Instance.lastInfo.difficulty)
            {
               case FightLibInfo.EASY:
                  this.selectedLevel = this._lowButton;
                  break;
               case FightLibInfo.NORMAL:
                  this.selectedLevel = this._mediumButton;
                  break;
               case FightLibInfo.DIFFICULT:
                  this.selectedLevel = this._highButton;
                  break;
               default:
                  return;
            }
            this.updateModel();
            this.updateModelII();
            this.updateLevelButtonState();
            this.updateAward();
            return;
         }
      }
      
      private function updateSencondType() : void
      {
         if(Boolean(FightLibManager.Instance.currentInfo) && (FightLibManager.Instance.currentInfo.id == LessonType.Twenty || FightLibManager.Instance.currentInfo.id == LessonType.SixtyFive || FightLibManager.Instance.currentInfo.id == LessonType.HighThrow))
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._sencondType = 6;
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._sencondType = 5;
            }
            else
            {
               this._sencondType = 3;
            }
         }
         else if(Boolean(FightLibManager.Instance.currentInfo) && FightLibManager.Instance.currentInfo.id == LessonType.HighGap)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._sencondType = 5;
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._sencondType = 4;
            }
            else
            {
               this._sencondType = 3;
            }
         }
      }
      
      private function updateLessonButtonState() : void
      {
         if(Boolean(FightLibManager.Instance.getFightLibInfoByID(LessonType.Measure)))
         {
            this._measureButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.Measure).InfoCanPlay;
         }
         else
         {
            this._measureButton.enabled = false;
         }
         if(Boolean(FightLibManager.Instance.getFightLibInfoByID(LessonType.Twenty)))
         {
            this._twentyButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.Twenty).InfoCanPlay;
         }
         else
         {
            this._twentyButton.enabled = false;
         }
         if(Boolean(FightLibManager.Instance.getFightLibInfoByID(LessonType.SixtyFive)))
         {
            this._sixtyFiveButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.SixtyFive).InfoCanPlay;
         }
         else
         {
            this._sixtyFiveButton.enabled = false;
         }
         if(Boolean(FightLibManager.Instance.getFightLibInfoByID(LessonType.HighThrow)))
         {
            this._highThrowButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.HighThrow).InfoCanPlay;
         }
         else
         {
            this._highThrowButton.enabled = false;
         }
         if(Boolean(FightLibManager.Instance.getFightLibInfoByID(LessonType.HighGap)))
         {
            this._highGapButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.HighGap).InfoCanPlay;
         }
         else
         {
            this._highGapButton.enabled = false;
         }
      }
      
      private function updateLevelButtonState() : void
      {
         if(FightLibManager.Instance.currentInfo != null)
         {
            this._lowButton.enable = FightLibManager.Instance.currentInfo.easyCanPlay;
            this._mediumButton.enable = FightLibManager.Instance.currentInfo.normalCanPlay;
            this._highButton.enable = FightLibManager.Instance.currentInfo.difficultCanPlay;
         }
         else
         {
            this._lowButton.enable = this._mediumButton.enable = this._highButton.enable = false;
         }
      }
      
      private function updateAward() : void
      {
         if(FightLibManager.Instance.currentInfo != null && FightLibManager.Instance.currentInfo.difficulty > -1)
         {
            this._awardView.visible = true;
            this._awardView.setGiftAndExpNum(FightLibManager.Instance.currentInfo.getAwardGiftsNum(),FightLibManager.Instance.currentInfo.getAwardEXPNum(),FightLibManager.Instance.currentInfo.getAwardMedal());
            this._awardView.setAwardItems(FightLibManager.Instance.currentInfo.getAwardItems());
            this._awardView.geted = false;
            this._defaultImg.visible = false;
            this.updateAwardGainedState();
         }
         else
         {
            this._awardView.visible = false;
            this._defaultImg.visible = true;
         }
      }
      
      private function updateAwardGainedState() : void
      {
         if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
         {
            if(FightLibManager.Instance.currentInfo.easyAwardGained)
            {
               this._awardView.geted = true;
            }
         }
         else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
         {
            if(FightLibManager.Instance.currentInfo.normalAwardGained)
            {
               this._awardView.geted = true;
            }
         }
         else if(FightLibManager.Instance.currentInfo.difficultAwardGained)
         {
            this._awardView.geted = true;
         }
      }
      
      private function addEvent() : void
      {
         this._measureButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._twentyButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._sixtyFiveButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highThrowButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highGapButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._startButton.addEventListener(MouseEvent.CLICK,this.__start);
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__cancel);
         this._lowButton.addEventListener(MouseEvent.CLICK,this.__levelClick);
         this._mediumButton.addEventListener(MouseEvent.CLICK,this.__levelClick);
         this._highButton.addEventListener(MouseEvent.CLICK,this.__levelClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__update);
         FightLibManager.Instance.addEventListener(FightLibManager.GAINAWARD,this.__gainAward);
      }
      
      private function __gainAward(evt:Event) : void
      {
      }
      
      private function __update(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["fightLibMission"]))
         {
            this.updateLessonButtonState();
            this.updateLevelButtonState();
            this.updateAward();
         }
      }
      
      private function removeEvent() : void
      {
         this._measureButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._twentyButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._sixtyFiveButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highThrowButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highGapButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._startButton.removeEventListener(MouseEvent.CLICK,this.__start);
         this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__cancel);
         this._lowButton.removeEventListener(MouseEvent.CLICK,this.__levelClick);
         this._mediumButton.removeEventListener(MouseEvent.CLICK,this.__levelClick);
         this._highButton.removeEventListener(MouseEvent.CLICK,this.__levelClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__update);
         FightLibManager.Instance.removeEventListener(FightLibManager.GAINAWARD,this.__gainAward);
      }
      
      private function __levelClick(evt:MouseEvent) : void
      {
         var button:LevelButton = null;
         var element:LessonButton = null;
         SoundManager.instance.play("008");
         if(FightLibManager.Instance.currentInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.ChooseFightLibTypeView.selectFightLibInfo"));
            for each(element in this._lessonButtons)
            {
               element.shine = element.enabled == true;
            }
            return;
         }
         for each(button in this._levelButtons)
         {
            if(button.enable)
            {
               button.shine = false;
            }
         }
         this.unselectedAllLevel();
         this.selectedLevel = evt.currentTarget as LevelButton;
         this.updateModelII();
         this.updateAward();
         this.updateSencondType();
         GameInSocketOut.sendGameRoomSetUp(FightLibManager.Instance.currentInfo.id,5,false,"","",this._sencondType,FightLibManager.Instance.currentInfo.difficulty,0,false,0);
         if(evt.currentTarget == this._lowButton && FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
         {
            FightLibManager.Instance.script.continueScript();
            FightLibManager.Instance.script.dispose();
            FightLibManager.Instance.script = null;
         }
      }
      
      private function updateModelII() : void
      {
         if(this._lowButton.selected)
         {
            FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.EASY;
         }
         else if(this._mediumButton.selected)
         {
            FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.NORMAL;
         }
         else if(this._highButton.selected)
         {
            FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.DIFFICULT;
         }
      }
      
      private function __selectLesson(evt:Event) : void
      {
         var lesson:LessonButton = null;
         var level:LevelButton = null;
         var button:LessonButton = evt.currentTarget as LessonButton;
         var newType:int = button.type;
         SoundManager.instance.play("008");
         if(Boolean(this._selectedLesson) && this._selectedLesson.type == newType)
         {
            return;
         }
         for each(lesson in this._lessonButtons)
         {
            if(lesson.enabled)
            {
               lesson.shine = false;
            }
         }
         for each(level in this._levelButtons)
         {
            if(level.enable)
            {
               level.shine = false;
            }
         }
         this.unSelectedAllLesson();
         this.unselectedAllLevel();
         this.selectedLesson = button;
         this.updateModel();
         this.updateLevelButtonState();
         if(newType == LessonType.Measure && FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
         {
            FightLibManager.Instance.script.continueScript();
         }
      }
      
      private function unSelectedAllLesson() : void
      {
         var element:LessonButton = null;
         for each(element in this._lessonButtons)
         {
            element.selected = false;
         }
      }
      
      private function unselectedAllLevel() : void
      {
         this._lowButton.selected = this._mediumButton.selected = this._highButton.selected = false;
      }
      
      private function updateModel() : void
      {
         FightLibManager.Instance.currentInfoID = this.selectedLesson.type;
         FightLibManager.Instance.currentInfo.difficulty = -1;
         this.updateAward();
      }
      
      private function __start(evt:MouseEvent) : void
      {
         var element:LessonButton = null;
         var button:LevelButton = null;
         SoundManager.instance.play("008");
         if(FightLibManager.Instance.currentInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.ChooseFightLibTypeView.selectFightLibInfo"));
            for each(element in this._lessonButtons)
            {
               element.shine = element.enabled == true;
            }
            return;
         }
         if(FightLibManager.Instance.currentInfo.difficulty < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.ChooseFightLibTypeView.selectDifficulty"));
            for each(button in this._levelButtons)
            {
               button.shine = button.enable == true;
            }
            return;
         }
         if(PlayerManager.Instance.Self.WeaponID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         this._startButton.visible = false;
         this._cancelButton.visible = true;
         GameInSocketOut.sendGameStart();
      }
      
      private function __cancel(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendCancelWait();
         this._cancelButton.visible = false;
         this._startButton.visible = true;
      }
      
      public function hideShine() : void
      {
         var lesson:LessonButton = null;
         var level:LevelButton = null;
         for each(lesson in this._lessonButtons)
         {
            if(lesson.enabled)
            {
               lesson.shine = false;
            }
         }
         for each(level in this._levelButtons)
         {
            if(level.enable)
            {
               level.shine = false;
            }
         }
      }
      
      public function showShine(type:int) : void
      {
         var lesson:LessonButton = null;
         var level:LevelButton = null;
         if(type == 1)
         {
            for each(lesson in this._lessonButtons)
            {
               if(lesson.enabled)
               {
                  lesson.shine = true;
               }
            }
         }
         else if(type == 2)
         {
            for each(level in this._levelButtons)
            {
               if(level.enable)
               {
                  level.shine = true;
               }
            }
         }
      }
      
      public function getGuild() : MovieClip
      {
         return this._guildMovie;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
            this._background = null;
         }
         ObjectUtils.disposeObject(this._defaultImg);
         this._defaultImg = null;
         ObjectUtils.disposeObject(this._background2);
         this._background2 = null;
         if(Boolean(this._difficultyImg))
         {
            ObjectUtils.disposeObject(this._difficultyImg);
            this._difficultyImg = null;
         }
         ObjectUtils.disposeObject(this._background3);
         this._background3 = null;
         if(Boolean(this._background4))
         {
            ObjectUtils.disposeObject(this._background4);
            this._background4 = null;
         }
         if(Boolean(this._awardView))
         {
            ObjectUtils.disposeObject(this._awardView);
            this._awardView = null;
         }
         if(Boolean(this._cancelButton))
         {
            ObjectUtils.disposeObject(this._cancelButton);
            this._cancelButton = null;
         }
         if(Boolean(this._guildMovie))
         {
            ObjectUtils.disposeObject(this._guildMovie);
            this._guildMovie = null;
         }
         if(Boolean(this._highButton))
         {
            ObjectUtils.disposeObject(this._highButton);
            this._highButton = null;
         }
         if(Boolean(this._highGapButton))
         {
            ObjectUtils.disposeObject(this._highGapButton);
            this._highGapButton = null;
         }
         if(Boolean(this._highThrowButton))
         {
            ObjectUtils.disposeObject(this._highThrowButton);
            this._highThrowButton = null;
         }
         if(Boolean(this._lassButton))
         {
            ObjectUtils.disposeObject(this._lassButton);
            this._lassButton = null;
         }
         if(Boolean(this._lowButton))
         {
            ObjectUtils.disposeObject(this._lowButton);
            this._lowButton = null;
         }
         if(Boolean(this._measureButton))
         {
            ObjectUtils.disposeObject(this._measureButton);
            this._measureButton = null;
         }
         if(Boolean(this._mediumButton))
         {
            ObjectUtils.disposeObject(this._mediumButton);
            this._mediumButton = null;
         }
         if(Boolean(this._sixtyFiveButton))
         {
            ObjectUtils.disposeObject(this._sixtyFiveButton);
            this._sixtyFiveButton = null;
         }
         if(Boolean(this._startButton))
         {
            ObjectUtils.disposeObject(this._startButton);
            this._startButton = null;
         }
         if(Boolean(this._twentyButton))
         {
            ObjectUtils.disposeObject(this._twentyButton);
            this._twentyButton = null;
         }
         this._selectedLesson = null;
         this._selectedLevel = null;
      }
      
      public function set selectedLesson(val:LessonButton) : void
      {
         var lastLesson:LessonButton = this._selectedLesson;
         this._selectedLesson = val;
         this._selectedLesson.selected = true;
         if(Boolean(lastLesson) && lastLesson != this._selectedLesson)
         {
            lastLesson.selected = false;
         }
      }
      
      public function get selectedLesson() : LessonButton
      {
         return this._selectedLesson;
      }
      
      public function set selectedLevel(val:LevelButton) : void
      {
         var lastLevel:LevelButton = this._selectedLevel;
         this._selectedLevel = val;
         this._selectedLevel.selected = true;
         if(Boolean(lastLevel) && lastLevel != this._selectedLevel)
         {
            lastLevel.selected = false;
         }
      }
      
      public function get selectedLevel() : LevelButton
      {
         return this._selectedLevel;
      }
   }
}

