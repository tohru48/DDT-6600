package ddt.view.vote
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.VoteManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   
   public class VoteView extends Frame
   {
      
      public static var OK_CLICK:String = "Ok_click";
      
      public static var VOTEVIEW_CLOSE:String = "voteView_close";
      
      private static var CELL_1_GOODS:int = 11904;
      
      private static var CELL_2_GOODS:int = 11032;
      
      private static var TWOLINEHEIGHT:int = 31;
      
      private static var questionBGHeight_2line:int = 188;
      
      private static var questionBGY_2line:int = 143;
      
      private static var questionContentY_2line:int = 158;
      
      private static const NUMBER:int = 2;
      
      private var _voteInfo:VoteQuestionInfo;
      
      private var _choseAnswerID:int;
      
      private var _itemArr:Vector.<VoteSelectItem>;
      
      private var _answerGroup:SelectedButtonGroup;
      
      private var _okBtn:TextButton;
      
      private var _answerBG:ScaleBitmapImage;
      
      private var _questionContent:FilterFrameText;
      
      private var _voteProgress:FilterFrameText;
      
      private var _selectSp:Sprite;
      
      private var _bg:ScaleBitmapImage;
      
      private var _itemList:SimpleTileList;
      
      private var _inputTxt:FilterFrameText;
      
      private var _defaultInputTxt:FilterFrameText;
      
      private var panel:ScrollPanel;
      
      public function VoteView()
      {
         super();
         this.addEvent();
      }
      
      public function get choseAnswerID() : int
      {
         return this._choseAnswerID;
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemArr = new Vector.<VoteSelectItem>();
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("ddt.view.vote.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vote.VoteView.bg");
         this._answerBG = ComponentFactory.Instance.creatComponentByStylename("vote.answerBG");
         this._questionContent = ComponentFactory.Instance.creat("vote.questionContent");
         this._voteProgress = ComponentFactory.Instance.creat("vote.progress");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("vote.okBtn");
         this._selectSp = new Sprite();
         this._itemList = ComponentFactory.Instance.creatCustomObject("vote.itemList",[NUMBER]);
         this.panel = ComponentFactory.Instance.creatComponentByStylename("vote.vote.VoteanswerPanel");
         this.panel.setView(this._itemList);
         addToContent(this._bg);
         addToContent(this._okBtn);
         this._selectSp.x = -4;
         this._selectSp.y = 58;
         this._selectSp.addChild(this._answerBG);
         this._selectSp.addChild(this._questionContent);
         this._selectSp.addChild(this._voteProgress);
         this._selectSp.addChild(this.panel);
         addToContent(this._selectSp);
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
      }
      
      public function set info(voteInfo:VoteQuestionInfo) : void
      {
         this._voteInfo = voteInfo;
         if(this._voteInfo.questionType == 1)
         {
            this._itemList.hSpace = 60;
         }
         else if(this._voteInfo.questionType == 2)
         {
            this._itemList.hSpace = 10;
         }
         this.update();
      }
      
      private function update() : void
      {
         var j:int = 0;
         var otherSelect:Boolean = false;
         var item:VoteSelectItem = null;
         this.clear();
         this._voteProgress.text = "进度" + VoteManager.Instance.count + "/" + VoteManager.Instance.questionLength;
         if(this._voteInfo.questionType == 1)
         {
            if(this._voteInfo.multiple)
            {
               this._answerGroup = new SelectedButtonGroup(true,this._voteInfo.answerLength);
            }
            else
            {
               this._answerGroup = new SelectedButtonGroup();
            }
            this._answerGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         }
         this._itemArr = new Vector.<VoteSelectItem>();
         var index:int = 0;
         this._questionContent.text = "    " + this._voteInfo.question;
         if(this._voteInfo.questionType != 3)
         {
            for(j = 0; j < this._voteInfo.answer.length; j++)
            {
               index++;
               if(this._voteInfo.questionType == 1 && this._voteInfo.otherSelect && j == this._voteInfo.answer.length - 1)
               {
                  otherSelect = true;
               }
               item = new VoteSelectItem(this._voteInfo.questionType,this._voteInfo.answer[j],otherSelect);
               item.text = index + ". " + this._voteInfo.answer[j].answer;
               this._itemList.addChild(item);
               this._itemArr.push(item);
               if(this._voteInfo.questionType == 1)
               {
                  this._answerGroup.addSelectItem(item.item);
               }
               item.initEvent();
            }
         }
         else
         {
            this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("vote.inputTxt");
            this._inputTxt.maxChars = 500;
            this._defaultInputTxt = ComponentFactory.Instance.creatComponentByStylename("vote.inputTxt");
            this._defaultInputTxt.text = LanguageMgr.GetTranslation("ddt.view.vote.defaultTxt");
            this._selectSp.addChild(this._inputTxt);
            this._selectSp.addChild(this._defaultInputTxt);
            this._inputTxt.setFocus();
            this._inputTxt.addEventListener(Event.CHANGE,this.__inputChangeHandler);
            this._inputTxt.addEventListener(FocusEvent.FOCUS_IN,this.__searchInputFocusIn);
            this._inputTxt.addEventListener(FocusEvent.FOCUS_OUT,this.__searchInputFocusOut);
         }
         this.panel.invalidateViewport();
      }
      
      private function __playSound(evt:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function clear() : void
      {
         this._questionContent.text = "";
         this._voteProgress.text = "";
         if(Boolean(this._answerGroup))
         {
            this._answerGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
            this._answerGroup.dispose();
            this._answerGroup = null;
         }
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            this._itemArr[i].dispose();
            this._itemArr[i] = null;
         }
         this._itemArr = null;
         if(Boolean(this._itemList))
         {
            this._itemList.removeAllChild();
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      protected function __inputChangeHandler(event:Event) : void
      {
         ObjectUtils.disposeObject(this._defaultInputTxt);
         this._defaultInputTxt = null;
         this._inputTxt.removeEventListener(Event.CHANGE,this.__inputChangeHandler);
      }
      
      protected function __searchInputFocusIn(event:FocusEvent) : void
      {
         ObjectUtils.disposeObject(this._defaultInputTxt);
         this._defaultInputTxt = null;
         this._inputTxt.removeEventListener(Event.CHANGE,this.__inputChangeHandler);
         if(this._inputTxt.text == LanguageMgr.GetTranslation("ddt.view.vote.defaultTxt"))
         {
            this._inputTxt.text = "";
         }
      }
      
      protected function __searchInputFocusOut(event:FocusEvent) : void
      {
         ObjectUtils.disposeObject(this._defaultInputTxt);
         this._defaultInputTxt = null;
         this._inputTxt.removeEventListener(Event.CHANGE,this.__inputChangeHandler);
         if(this._inputTxt.text.length == 0)
         {
            this._inputTxt.text = LanguageMgr.GetTranslation("ddt.view.vote.defaultTxt");
         }
      }
      
      protected function __changeHandler(event:Event) : void
      {
         if(this._itemArr[this._itemArr.length - 1].item.selected)
         {
            this._itemArr[this._itemArr.length - 1].inputEnable = true;
         }
         else
         {
            this._itemArr[this._itemArr.length - 1].inputEnable = false;
         }
      }
      
      private function __clickHandler(evt:MouseEvent) : void
      {
         var item:VoteSelectItem = null;
         var i:int = 0;
         var item2:VoteSelectItem = null;
         SoundManager.instance.play("008");
         var hasChosed:Boolean = false;
         if(this._voteInfo.questionType == 1)
         {
            for each(item in this._itemArr)
            {
               if(item.otherSelect && item.selected)
               {
                  if(item.content == "")
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.vote.choseOne3"));
                     return;
                  }
                  hasChosed = true;
                  break;
               }
            }
            if(!hasChosed)
            {
               for(i = 0; i < this._itemArr.length; i++)
               {
                  if(this._itemArr[i].selected)
                  {
                     hasChosed = true;
                     break;
                  }
               }
            }
         }
         else if(this._voteInfo.questionType == 2)
         {
            hasChosed = true;
            for each(item2 in this._itemArr)
            {
               if(item2.score == 0)
               {
                  hasChosed = false;
                  break;
               }
            }
         }
         else if(this._inputTxt && this._inputTxt.text != LanguageMgr.GetTranslation("ddt.view.vote.defaultTxt") && this._inputTxt.text.length > 0)
         {
            hasChosed = true;
         }
         if(!hasChosed)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.vote.choseOne" + this._voteInfo.questionType));
            return;
         }
         dispatchEvent(new Event(OK_CLICK));
      }
      
      public function get selectAnswer() : String
      {
         var i:int = 0;
         var item:VoteSelectItem = null;
         var str:String = this._voteInfo.questionType + "|";
         if(this._voteInfo.questionType != 3)
         {
            for(i = 0; i < this._itemArr.length; i++)
            {
               item = this._itemArr[i];
               if(!item.selected)
               {
                  continue;
               }
               switch(this._voteInfo.questionType)
               {
                  case 1:
                     if(item.otherSelect)
                     {
                        str = str + item.answerId + "," + item.content + "|";
                     }
                     else
                     {
                        str = str + item.answerId + "|";
                     }
                     break;
                  case 2:
                     str = str + item.answerId + "," + item.score + "|";
                     break;
               }
            }
         }
         else
         {
            str = str + this._voteInfo.questionID + "," + this._inputTxt.text + "|";
         }
         return str;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(Boolean(this._inputTxt))
         {
            this._inputTxt.removeEventListener(Event.CHANGE,this.__inputChangeHandler);
            this._inputTxt.removeEventListener(FocusEvent.FOCUS_IN,this.__searchInputFocusIn);
            this._inputTxt.removeEventListener(FocusEvent.FOCUS_OUT,this.__searchInputFocusOut);
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               dispatchEvent(new Event(VOTEVIEW_CLOSE));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         super.dispose();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._answerBG))
         {
            ObjectUtils.disposeObject(this._answerBG);
         }
         this._answerBG = null;
         if(Boolean(this._answerGroup))
         {
            ObjectUtils.disposeObject(this._answerGroup);
         }
         this._answerGroup = null;
         if(Boolean(this._okBtn))
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(Boolean(this._questionContent))
         {
            ObjectUtils.disposeObject(this._questionContent);
         }
         this._questionContent = null;
         if(Boolean(this._voteProgress))
         {
            ObjectUtils.disposeObject(this._voteProgress);
         }
         this._voteProgress = null;
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         ObjectUtils.disposeObject(this._defaultInputTxt);
         this._defaultInputTxt = null;
         ObjectUtils.disposeObject(this._selectSp);
         this._selectSp = null;
         ObjectUtils.disposeObject(this._itemList);
         this._itemList = null;
         ObjectUtils.disposeObject(this.panel);
         this.panel = null;
         this._voteInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

