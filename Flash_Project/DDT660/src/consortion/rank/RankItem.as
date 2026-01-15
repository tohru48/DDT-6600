package consortion.rank
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class RankItem extends Sprite
   {
      
      private static const NO1:int = 1;
      
      private static const NO2:int = 2;
      
      private static const NO3:int = 3;
      
      private var _back1:Bitmap;
      
      private var _back2:Bitmap;
      
      private var _data:RankData;
      
      private var _threeTh:ScaleFrameImage;
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _zoneTxt:FilterFrameText;
      
      private var _light:Bitmap;
      
      public function RankItem(data:RankData)
      {
         super();
         this._data = data;
         this.initView();
      }
      
      protected function initView() : void
      {
         this._back1 = ComponentFactory.Instance.creat("consortion.item.back1");
         addChild(this._back1);
         this._back1.visible = false;
         this._back2 = ComponentFactory.Instance.creat("consortion.item.back2");
         addChild(this._back2);
         this._back2.visible = false;
         this._threeTh = ComponentFactory.Instance.creat("consortion.rankThreeRink");
         addChild(this._threeTh);
         this._threeTh.visible = false;
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.rankTxt");
         addChild(this._rankTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.text = this._data.Name;
         if(this._nameTxt.text.length > 11)
         {
            this._nameTxt.text = this._nameTxt.text.substr(0,8) + "...";
         }
         this._zoneTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.scoreTxt");
         this._zoneTxt.text = this._data.ZoneName;
         this._zoneTxt.visible = false;
         this._zoneTxt.x = 244;
         this._zoneTxt.y = 3;
         addChild(this._zoneTxt);
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.scoreTxt");
         addChild(this._scoreTxt);
         this._scoreTxt.text = this._data.Score.toString();
         this.initRank();
      }
      
      public function setCampBattleStlye(bool:Boolean) : void
      {
         this._back1.visible = bool;
         this._back2.visible = bool;
         this._zoneTxt.visible = !bool;
         this._zoneTxt.x = 217;
         this._nameTxt.autoSize = TextFieldAutoSize.CENTER;
         this._nameTxt.x = 54;
         this._nameTxt.y = 1;
         this._scoreTxt.x = 331;
         this._scoreTxt.y = 1;
         this._scoreTxt.autoSize = TextFieldAutoSize.CENTER;
         this._threeTh.x = -4;
         this._threeTh.y = 0;
         this._rankTxt.x = 2;
      }
      
      private function initRank() : void
      {
         if(this._data.Rank == NO1)
         {
            this._threeTh.setFrame(1);
            this._threeTh.visible = true;
         }
         else if(this._data.Rank == NO2)
         {
            this._threeTh.setFrame(2);
            this._threeTh.visible = true;
         }
         else if(this._data.Rank == NO3)
         {
            this._threeTh.setFrame(3);
            this._threeTh.visible = true;
         }
         else
         {
            this._rankTxt.text = this._data.Rank + "th";
         }
      }
      
      public function setView(num:int) : void
      {
         if(Boolean(num % 2))
         {
            this._back1.visible = true;
         }
         else
         {
            this._back2.visible = true;
         }
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

