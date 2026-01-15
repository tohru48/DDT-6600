package eliteGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import eliteGame.info.EliteGameScroeRankInfo;
   import flash.display.Sprite;
   
   public class EliteGameScoreRankItem extends Sprite implements Disposeable
   {
      
      private var _topThree:ScaleFrameImage;
      
      private var _rank:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _score:FilterFrameText;
      
      private var _line11:ScaleBitmapImage;
      
      private var _line22:ScaleBitmapImage;
      
      public function EliteGameScoreRankItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._line11 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.line11");
         this._line22 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.line22");
         addChild(this._line11);
         addChild(this._line22);
         this._topThree = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreRankView.topThree");
         this._rank = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreItem.rank");
         this._name = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreItem.name");
         this._score = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.scoreItem.score");
         addChild(this._topThree);
         addChild(this._rank);
         addChild(this._name);
         addChild(this._score);
         this._topThree.visible = false;
      }
      
      public function set info(info:EliteGameScroeRankInfo) : void
      {
         switch(info.rank)
         {
            case 1:
               this._topThree.setFrame(1);
               this._topThree.visible = true;
               this._rank.visible = false;
               break;
            case 2:
               this._topThree.setFrame(2);
               this._topThree.visible = true;
               this._rank.visible = false;
               break;
            case 3:
               this._topThree.setFrame(3);
               this._topThree.visible = true;
               this._rank.visible = false;
               break;
            default:
               this._rank.text = info.rank + "th";
               this._topThree.visible = false;
               this._rank.visible = true;
         }
         this._name.text = info.nickName;
         this._score.text = info.scroe.toString();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._line22))
         {
            ObjectUtils.disposeObject(this._line11);
         }
         this._line22 = null;
         if(Boolean(this._line22))
         {
            ObjectUtils.disposeObject(this._line22);
         }
         this._line22 = null;
         if(Boolean(this._rank))
         {
            ObjectUtils.disposeObject(this._rank);
         }
         this._rank = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._score))
         {
            ObjectUtils.disposeObject(this._score);
         }
         this._score = null;
         if(Boolean(this._topThree))
         {
            ObjectUtils.disposeObject(this._topThree);
         }
         this._topThree = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

