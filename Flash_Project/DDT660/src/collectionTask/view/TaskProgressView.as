package collectionTask.view
{
   import collectionTask.CollectionTaskManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TaskProgressView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _infoBtn:SimpleBitmapButton;
      
      private var _title:FilterFrameText;
      
      private var _progressTxtArr:Array;
      
      private var _progressDescArr:Array;
      
      private var _info:QuestInfo;
      
      private const CONDITION_ID:int = 64;
      
      public function TaskProgressView()
      {
         super();
         this.initView();
         this.refreshView();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var progressItem:TaskProgressItem = null;
         this._bg = ComponentFactory.Instance.creatBitmap("collectionTask.infoBgAsset");
         addChild(this._bg);
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("collectionTask.infoViewButton");
         this._infoBtn.mouseEnabled = false;
         addChild(this._infoBtn);
         this._title = ComponentFactory.Instance.creatComponentByStylename("collectionTask.title1Txt");
         addChild(this._title);
         this._info = CollectionTaskManager.Instance.questInfo;
         this._title.text = this._info.Title;
         this._progressTxtArr = new Array();
         this._progressDescArr = this._info.conditionProgress;
         for(i = 0; i < this._progressDescArr.length; i++)
         {
            progressItem = new TaskProgressItem();
            addChild(progressItem);
            progressItem.x = 27;
            progressItem.y = 15 + 29 * (i + 1);
            this._progressTxtArr.push(progressItem);
         }
      }
      
      public function refreshView() : void
      {
         this._progressDescArr = this._info.conditionProgress;
         for(var i:int = 0; i < this._progressTxtArr.length; i++)
         {
            (this._progressTxtArr[i] as TaskProgressItem).refresh(this._progressDescArr[i]);
         }
         CollectionTaskManager.Instance.isTaskComplete = this._info.isCompleted;
      }
      
      public function dispose() : void
      {
         var item:TaskProgressItem = null;
         ObjectUtils.disposeObject(this._infoBtn);
         this._infoBtn = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         for each(item in this._progressTxtArr)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._progressTxtArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
   }
}

