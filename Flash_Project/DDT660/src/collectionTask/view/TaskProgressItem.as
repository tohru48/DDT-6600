package collectionTask.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class TaskProgressItem extends Sprite implements Disposeable
   {
      
      private var _nameTxt:FilterFrameText;
      
      private var _progressTxt:FilterFrameText;
      
      private var _nameStr:String;
      
      private var _progressStr:String;
      
      public function TaskProgressItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("collectionTask.progressTxt");
         addChild(this._nameTxt);
         PositionUtils.setPos(this._nameTxt,"task.namePos");
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("collectionTask.progressTxt");
         addChild(this._progressTxt);
         PositionUtils.setPos(this._progressTxt,"task.progressPos");
      }
      
      public function refresh(desc:String) : void
      {
         this._nameStr = desc.split(",")[0];
         this._progressStr = desc.split(",")[1];
         this._nameTxt.text = this._nameStr;
         this._progressTxt.text = this._progressStr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._progressTxt);
         this._progressTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

