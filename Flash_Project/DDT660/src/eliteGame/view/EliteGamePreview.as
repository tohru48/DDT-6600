package eliteGame.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EliteGamePreview extends Frame
   {
      
      public static const SCORE_RANK:int = 0;
      
      public static const ELITEGAME_RULE:int = 1;
      
      public static const TYPE30_40:int = 0;
      
      public static const TYPE41_50:int = 1;
      
      private var _bg:ScaleBitmapImage;
      
      private var _scoreRankBtn:SelectedButton;
      
      private var _ruleBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _scoreRankView:EliteGameScoreRankView;
      
      private var _rule:EliteGameRuleView;
      
      public function EliteGamePreview()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.bg");
         this._scoreRankBtn = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.scoreRankBtn");
         this._ruleBtn = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleBtn");
         titleText = LanguageMgr.GetTranslation("EliteGame.Title");
         addToContent(this._bg);
         addToContent(this._scoreRankBtn);
         addToContent(this._ruleBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._scoreRankBtn);
         this._btnGroup.addSelectItem(this._ruleBtn);
         this._btnGroup.selectIndex = 1;
         this.showType(ELITEGAME_RULE);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__btnChangeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__btnChangeHandler);
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __btnChangeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.showType(this._btnGroup.selectIndex);
      }
      
      private function showType(type:int) : void
      {
         switch(type)
         {
            case SCORE_RANK:
               if(this._scoreRankView == null)
               {
                  this._scoreRankView = ComponentFactory.Instance.creatCustomObject("ddteliteGameScoreRankView");
                  addToContent(this._scoreRankView);
               }
               this._scoreRankView.visible = true;
               if(Boolean(this._rule))
               {
                  this._rule.visible = false;
               }
               break;
            case ELITEGAME_RULE:
               if(this._rule == null)
               {
                  this._rule = ComponentFactory.Instance.creatCustomObject("ddteliteGameRuleView");
                  addToContent(this._rule);
               }
               if(Boolean(this._scoreRankView))
               {
                  this._scoreRankView.visible = false;
               }
               this._rule.visible = true;
         }
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._scoreRankBtn))
         {
            ObjectUtils.disposeObject(this._scoreRankBtn);
         }
         this._scoreRankBtn = null;
         if(Boolean(this._ruleBtn))
         {
            ObjectUtils.disposeObject(this._ruleBtn);
         }
         this._ruleBtn = null;
         if(Boolean(this._scoreRankView))
         {
            this._scoreRankView.dispose();
         }
         this._scoreRankView = null;
         if(Boolean(this._rule))
         {
            this._rule.dispose();
         }
         this._rule = null;
         super.dispose();
      }
   }
}

