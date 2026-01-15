package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import game.model.Player;
   import game.view.playerThumbnail.HeadFigure;
   
   public class ExpFriendItem extends Sprite implements Disposeable
   {
      
      private var _head:HeadFigure;
      
      private var _nameTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _exploitTxt:FilterFrameText;
      
      public function ExpFriendItem(player:Player)
      {
         super();
         this.init(player);
      }
      
      private function init(player:Player) : void
      {
         var tempIndex:int = 0;
         this._head = new HeadFigure(28,28,player);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewNameTxt");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewScoreTxt");
         this._exploitTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewScoreTxt");
         PositionUtils.setPos(this._exploitTxt,"experience.FriendItemTxtPos_3");
         PositionUtils.setPos(this._head,"experience.FriendItemHeadPos");
         this._nameTxt.text = player.playerInfo.NickName;
         if(this._nameTxt.width > 85)
         {
            tempIndex = this._nameTxt.getCharIndexAtPoint(85,5);
            this._nameTxt.text = this._nameTxt.text.substring(0,tempIndex) + "...";
         }
         this._expTxt.text = "+" + player.expObj.gainGP;
         if(Boolean(player.expObj.gainOffer))
         {
            if(player.GainOffer < 0)
            {
               this._exploitTxt.text = player.GainOffer.toString();
            }
            else
            {
               this._exploitTxt.text = "+" + player.GainOffer.toString();
            }
         }
         else
         {
            this._exploitTxt.text = "+0";
         }
         addChild(this._head);
         addChild(this._nameTxt);
         addChild(this._expTxt);
         addChild(this._exploitTxt);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._head))
         {
            this._head.dispose();
            this._head = null;
         }
         if(Boolean(this._nameTxt))
         {
            this._nameTxt.dispose();
            this._nameTxt = null;
         }
         if(Boolean(this._expTxt))
         {
            this._expTxt.dispose();
            this._expTxt = null;
         }
         if(Boolean(this._exploitTxt))
         {
            this._exploitTxt.dispose();
            this._exploitTxt = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

