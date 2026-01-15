package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import vip.VipController;
   
   public class SuperWinnerPlayerItem extends Sprite implements Disposeable, IListCell
   {
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _name:FilterFrameText;
      
      private var _vipName:GradientText;
      
      public function SuperWinnerPlayerItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._name = ComponentFactory.Instance.creat("asset.superWinner.playerlist.name");
         addChild(this._name);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("asset.superWinner.PlayerItem.SexIcon");
         addChild(this._sexIcon);
      }
      
      public function dispose() : void
      {
         this._name = null;
         this._levelIcon = null;
         this._sexIcon = null;
         this._vipName = null;
         ObjectUtils.removeChildAllChildren(this);
      }
      
      public function get sexIcon() : SexIcon
      {
         return this._sexIcon;
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return null;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value;
         this.update();
      }
      
      private function update() : void
      {
         ObjectUtils.disposeObject(this._vipName);
         if(this._info.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(120,this._info.typeVIP);
            this._vipName.x = this._name.x;
            this._vipName.y = this._name.y;
            this._vipName.text = this._info.NickName;
            addChild(this._vipName);
         }
         this._name.text = this._info.NickName;
         PositionUtils.adaptNameStyle(this._info,this._name,this._vipName);
         this._sexIcon.setSex(this._info.Sex);
         this._levelIcon.setInfo(this._info.Grade,0,0,0,0,0,false);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

