package lanternriddles.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import lanternriddles.data.LanternInfo;
   import vip.VipController;
   
   public class LanternRankItem extends Sprite
   {
      
      private var _id:int;
      
      private var _topThreeRank:ScaleFrameImage;
      
      private var _rankNum:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nickName:FilterFrameText;
      
      private var _integral:FilterFrameText;
      
      private var _award:LanternRankItemAward;
      
      private var _info:LanternInfo;
      
      public function LanternRankItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._topThreeRank = ComponentFactory.Instance.creat("lantern.view.topThreeRank");
         addChild(this._topThreeRank);
         this._topThreeRank.visible = false;
         this._rankNum = ComponentFactory.Instance.creatComponentByStylename("lantern.view.rankNum");
         addChild(this._rankNum);
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("lantern.view.nickName");
         addChild(this._nickName);
         this._integral = ComponentFactory.Instance.creatComponentByStylename("lantern.view.integral");
         addChild(this._integral);
         this._award = new LanternRankItemAward();
         PositionUtils.setPos(this._award,"lantern.view.rankAwardPos");
         addChild(this._award);
      }
      
      public function set info(info:LanternInfo) : void
      {
         this._info = info;
         this.setRankNum(this._info.Rank);
         this.addNickName();
         this._integral.text = this._info.Integer.toString();
         if(Boolean(this._info.AwardInfoVec))
         {
            this._award.info = this._info.AwardInfoVec;
         }
      }
      
      private function addNickName() : void
      {
         var textFormat:TextFormat = null;
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         this._nickName.visible = !this._info.IsVIP;
         if(this._info.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(1,1);
            textFormat = new TextFormat();
            textFormat.align = "center";
            textFormat.bold = true;
            this._vipName.textField.defaultTextFormat = textFormat;
            this._vipName.textSize = 16;
            this._vipName.textField.width = this._nickName.width;
            this._vipName.x = this._nickName.x;
            this._vipName.y = this._nickName.y;
            this._vipName.text = this._info.NickName;
            addChild(this._vipName);
         }
         else
         {
            this._nickName.text = this._info.NickName;
         }
      }
      
      private function setRankNum(num:int) : void
      {
         this._id = num;
         if(num <= 3)
         {
            this._topThreeRank.visible = true;
            this._topThreeRank.setFrame(num);
            this._rankNum.visible = false;
         }
         else
         {
            this._rankNum.text = num.toString() + "th";
            this._topThreeRank.visible = false;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._rankNum))
         {
            this._rankNum.dispose();
            this._rankNum = null;
         }
         if(Boolean(this._topThreeRank))
         {
            this._topThreeRank.dispose();
            this._topThreeRank = null;
         }
         if(Boolean(this._nickName))
         {
            this._nickName.dispose();
            this._nickName = null;
         }
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         if(Boolean(this._integral))
         {
            this._integral.dispose();
            this._integral = null;
         }
         if(Boolean(this._award))
         {
            this._award.dispose();
            this._award = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}

