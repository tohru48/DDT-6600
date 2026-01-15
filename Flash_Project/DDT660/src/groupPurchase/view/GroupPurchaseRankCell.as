package groupPurchase.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class GroupPurchaseRankCell extends Sprite implements Disposeable
   {
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      public function GroupPurchaseRankCell()
      {
         super();
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.rankCell.rankTxt");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.rankCell.nameTxt");
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.rankCell.numTxt");
         addChild(this._rankTxt);
         addChild(this._nameTxt);
         addChild(this._numTxt);
      }
      
      public function refreshView(data:Object) : void
      {
         if(Boolean(data))
         {
            this._rankTxt.text = data.rank;
            this._nameTxt.text = data.name;
            this._numTxt.text = data.num;
         }
         else
         {
            this._rankTxt.text = "";
            this._nameTxt.text = "";
            this._numTxt.text = "";
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._rankTxt = null;
         this._nameTxt = null;
         this._numTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

