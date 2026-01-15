package times.updateView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class TimesUpdateViewCell extends Sprite implements Disposeable
   {
      
      private var _titleTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      public function TimesUpdateViewCell(param1:Object)
      {
         super();
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("timesUpdate.viewCell.titleTxt");
         this._titleTxt.text = "·" + param1.Title;
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("timesUpdate.viewCell.contentTxt");
         this._contentTxt.text = param1.Text;
         this._contentTxt.height = this._contentTxt.textHeight + 5;
         addChild(this._titleTxt);
         addChild(this._contentTxt);
         this.graphics.clear();
         this.graphics.lineStyle(1,5124638);
         this.graphics.moveTo(5,this._contentTxt.y + this._contentTxt.textHeight + 8);
         this.graphics.lineTo(5 + 685,this._contentTxt.y + this._contentTxt.textHeight + 8);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._titleTxt = null;
         this._contentTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

