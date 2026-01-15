package ddt.view.vote
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class VoteSelectItem extends Sprite implements Disposeable
   {
      
      private var _item:SelectedCheckButton;
      
      private var _textTxt:FilterFrameText;
      
      private var _scoreCombox:ComboBox;
      
      private var _scoreArr:Array = [1,2,3,4,5,6,7,8,9,10];
      
      private var _currentScore:int;
      
      private var _text:String;
      
      private var _type:int;
      
      private var _otherSelect:Boolean;
      
      private var _inputTxt:FilterFrameText;
      
      private var _inputBg:Scale9CornerImage;
      
      private var _voteInfo:VoteInfo;
      
      public function VoteSelectItem(type:int, voteInfo:VoteInfo, otherSelect:Boolean = false)
      {
         super();
         this._type = type;
         this._voteInfo = voteInfo;
         this._otherSelect = otherSelect;
         this.initView();
      }
      
      private function initView() : void
      {
         if(this._type == 1)
         {
            this._item = ComponentFactory.Instance.creatComponentByStylename("vote.answer.selectedBtn");
            addChild(this._item);
            if(this._otherSelect)
            {
               this._item.width = 93;
               this._inputBg = ComponentFactory.Instance.creatComponentByStylename("vote.inputBg");
               addChild(this._inputBg);
               this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("vote.otherSelect.inputTxt");
               this._inputTxt.maxChars = 60;
               this._inputTxt.mouseEnabled = false;
               addChild(this._inputTxt);
            }
         }
         else if(this._type == 2)
         {
            this._textTxt = ComponentFactory.Instance.creatComponentByStylename("vote.answerTxt");
            addChild(this._textTxt);
            this._textTxt.x = 23;
            this._textTxt.y = 7;
            this._scoreCombox = ComponentFactory.Instance.creatComponentByStylename("vote.scoreCombo");
            this._scoreCombox.selctedPropName = "text";
            this._scoreCombox.textField.text = "";
            addChild(this._scoreCombox);
            this.updateComboBox();
         }
      }
      
      public function initEvent() : void
      {
         if(this._type == 1)
         {
            this._item.addEventListener(MouseEvent.CLICK,this.__playSound);
         }
         else if(this._type == 2)
         {
            this._scoreCombox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         }
      }
      
      protected function __onListClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentScore = event.cellValue;
         this.updateComboBox(event.cellValue);
      }
      
      private function updateComboBox(obj:* = null) : void
      {
         var comboxModel:VectorListModel = this._scoreCombox.listPanel.vectorListModel;
         comboxModel.clear();
         comboxModel.appendAll(this._scoreArr);
         comboxModel.remove(obj);
      }
      
      private function __playSound(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._type == 1 && this._otherSelect)
         {
            if(!this._item.selected)
            {
               this.inputEnable = false;
            }
            else
            {
               this.inputEnable = true;
            }
         }
      }
      
      public function set inputEnable(value:Boolean) : void
      {
         if(this._type == 1 && this._otherSelect)
         {
            this._inputTxt.mouseEnabled = value;
         }
      }
      
      private function removeEvent() : void
      {
         if(this._type == 1)
         {
            this._item.removeEventListener(MouseEvent.CLICK,this.__playSound);
         }
         else if(this._type == 2)
         {
            this._scoreCombox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         }
      }
      
      public function get selected() : Boolean
      {
         if(this._type == 1)
         {
            return this._item.selected;
         }
         return true;
      }
      
      public function get selectedAnswer() : String
      {
         return "";
      }
      
      public function get item() : SelectedCheckButton
      {
         return this._item;
      }
      
      public function get otherSelect() : Boolean
      {
         return this._otherSelect;
      }
      
      public function get answerId() : String
      {
         return this._voteInfo.answerId;
      }
      
      public function get score() : int
      {
         return this._currentScore;
      }
      
      public function get content() : String
      {
         return this._inputTxt.text;
      }
      
      public function set text(value:String) : void
      {
         if(this._type == 1)
         {
            this._item.text = value;
         }
         else if(this._type == 2)
         {
            this._textTxt.text = value;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._item);
         this._item = null;
         ObjectUtils.disposeObject(this._scoreCombox);
         this._scoreCombox = null;
         ObjectUtils.disposeObject(this._textTxt);
         this._textTxt = null;
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

