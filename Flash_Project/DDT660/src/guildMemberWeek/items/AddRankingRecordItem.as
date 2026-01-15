package guildMemberWeek.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class AddRankingRecordItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _countTxt:FilterFrameText;
      
      public function AddRankingRecordItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.guildmemberweek.MainrightRecordBG.png");
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.Right.AddRankingRecordItem.countTxt");
         addChild(this._bg);
         addChild(this._countTxt);
      }
      
      public function initText(ShowText:String) : void
      {
         this._countTxt.text = ShowText;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

