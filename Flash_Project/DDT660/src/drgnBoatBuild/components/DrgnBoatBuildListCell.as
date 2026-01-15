package drgnBoatBuild.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import drgnBoatBuild.DrgnBoatBuildManager;
   import drgnBoatBuild.data.DrgnBoatBuildCellInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class DrgnBoatBuildListCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _bg:Image;
      
      private var _light:ScaleBitmapImage;
      
      private var _levelIcon:LevelIcon;
      
      private var _nameText:FilterFrameText;
      
      private var _canIcon:Bitmap;
      
      private var _vipName:GradientText;
      
      private var _info:DrgnBoatBuildCellInfo;
      
      private var _selected:Boolean = false;
      
      public function DrgnBoatBuildListCell()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.cellBg");
         addChild(this._bg);
         this._light = ComponentFactory.Instance.creatComponentByStylename("drgnboatBuild.light");
         this._light.visible = false;
         addChild(this._light);
         this._levelIcon = new LevelIcon();
         PositionUtils.setPos(this._levelIcon,"drgnBoatBuild.levelIconPos");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._nameText = ComponentFactory.Instance.creat("drgnBoatBuild.list.nameTxt");
         addChild(this._nameText);
         this._canIcon = ComponentFactory.Instance.creatBitmap("drgnBoatBuild.canIcon");
         this._canIcon.visible = false;
         addChild(this._canIcon);
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         addEventListener(MouseEvent.CLICK,this.__itemClick);
      }
      
      protected function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         DrgnBoatBuildManager.instance.selectedId = this._info.id;
         SocketManager.Instance.out.updateDrgnBoatBuildInfo(this._info.id);
      }
      
      protected function __itemOut(event:MouseEvent) : void
      {
         if(!this.isFriendSelected())
         {
            this._light.visible = false;
         }
      }
      
      protected function __itemOver(event:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         removeEventListener(MouseEvent.CLICK,this.__itemClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._light);
         this._light = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         ObjectUtils.disposeObject(this._canIcon);
         this._canIcon = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
      }
      
      private function isFriendSelected() : Boolean
      {
         if(DrgnBoatBuildManager.instance.selectedId == this._info.id)
         {
            return true;
         }
         return false;
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._bg.setFrame(index % 2 + 1);
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value;
         this.update();
      }
      
      private function update() : void
      {
         this._levelIcon.setInfo(this._info.playerinfo.Grade,this._info.playerinfo.Repute,this._info.playerinfo.WinCount,this._info.playerinfo.TotalCount,this._info.playerinfo.FightPower,this._info.playerinfo.Offer,true);
         if(this._info.playerinfo.IsVIP)
         {
            if(this._vipName == null)
            {
               this._vipName = VipController.instance.getVipNameTxt(100);
               addChild(this._vipName);
            }
            this._vipName.x = this._nameText.x;
            this._vipName.y = this._nameText.y;
            this._vipName.text = this._info.playerinfo.NickName;
            this._vipName.visible = true;
            this._nameText.visible = false;
         }
         else
         {
            if(Boolean(this._vipName))
            {
               this._vipName.visible = false;
            }
            this._nameText.visible = true;
         }
         this._nameText.text = this._info.playerinfo.NickName;
         this._canIcon.visible = this._info.canBuild;
         if(this.isFriendSelected())
         {
            this._light.visible = true;
         }
         else
         {
            this._light.visible = false;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

