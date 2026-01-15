package magpieBridge.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddtBuried.data.MapItemData;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import magpieBridge.MagpieBridgeManager;
   
   public class MagpieBridgeMap extends Sprite implements Disposeable
   {
      
      private static const ICON_WIDTH:int = 70;
      
      private var _mapArray:Array = [[1,1,1,1,4,4,3,3,4,4,4,4,1,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,4,4,4,3,3,4],[1,1,2,2,1,1,1,1,1,1,1,1,4,4,4,4,4,4,3,3,3,3,3,3,2,2,2,2,1,1,1,1,4,4,3],[1,1,4,4,3,4,4,4,1,1,1,2,2,2,2,1,1,1,2,2,1,1,1,4,4,4,4,4,4,3,3,3,3,2,2]];
      
      private var _mapVec:Vector.<Sprite>;
      
      private var _light:MovieClip;
      
      public function MagpieBridgeMap()
      {
         super();
         this.rotationX = -35;
         this.scaleY = 0.6;
         this._mapVec = new Vector.<Sprite>();
         this.initView();
      }
      
      private function initView() : void
      {
         this.creatMap();
         this.addProps();
      }
      
      private function creatMap() : void
      {
         var icon:Bitmap = null;
         var iconSprite:Sprite = null;
         var map:Array = this._mapArray[MagpieBridgeManager.instance.magpieModel.MapId];
         var begin:Bitmap = ComponentFactory.Instance.creat("asset.magpieMap.begin");
         var beginSprite:Sprite = new Sprite();
         beginSprite.addChild(begin);
         addChild(beginSprite);
         this._mapVec.push(beginSprite);
         for(var i:int = 0; i < map.length; i++)
         {
            icon = ComponentFactory.Instance.creat("asset.magpieMap.icon");
            iconSprite = new Sprite();
            iconSprite.addChild(icon);
            PositionUtils.setPos(iconSprite,this.getIconPos(this._mapVec[i],iconSprite,map[i]));
            addChild(iconSprite);
            this._mapVec.push(iconSprite);
         }
      }
      
      private function addProps() : void
      {
         var mapDataVec:Vector.<MapItemData> = null;
         var i:int = 0;
         var props:Bitmap = null;
         var magpieImage:ScaleFrameImage = null;
         var bagCellInfo:ItemTemplateInfo = null;
         var bagCell:BagCell = null;
         mapDataVec = MagpieBridgeManager.instance.magpieModel.MapDataVec;
         for(i = 0; i < mapDataVec.length; i++)
         {
            if(mapDataVec[i].tempID <= 0 && mapDataVec[i].tempID >= -5)
            {
               props = ComponentFactory.Instance.creat("asset.magpieMap.props" + mapDataVec[i].tempID.toString());
               props.x = (this._mapVec[mapDataVec[i].type].width - props.width) / 2;
               props.y = (this._mapVec[mapDataVec[i].type].height - props.height) / 2;
               this._mapVec[mapDataVec[i].type].addChild(props);
            }
            else if(mapDataVec[i].tempID == -6)
            {
               magpieImage = ComponentFactory.Instance.creatComponentByStylename("magpieBridge.magpieMap.magpieImage");
               magpieImage.x = (this._mapVec[mapDataVec[i].type].width - props.width) / 2;
               magpieImage.y = (this._mapVec[mapDataVec[i].type].height - props.height) / 2;
               magpieImage.tipData = LanguageMgr.GetTranslation("magpieBridgeView.magpie.tipsTxt");
               this._mapVec[mapDataVec[i].type].addChild(magpieImage);
            }
            else
            {
               bagCellInfo = ItemManager.Instance.getTemplateById(mapDataVec[i].tempID);
               bagCell = new BagCell(0,bagCellInfo);
               bagCell.setBgVisible(false);
               bagCell.width = this._mapVec[mapDataVec[i].type].width;
               bagCell.height = this._mapVec[mapDataVec[i].type].height;
               bagCell.x = 4;
               bagCell.y = 6;
               this._mapVec[mapDataVec[i].type].addChild(bagCell);
            }
         }
         this._light = ComponentFactory.Instance.creat("asset.magpieBridge.overLight");
         this._mapVec[this._mapVec.length - 1].addChildAt(this._light,0);
      }
      
      public function closeIcon() : void
      {
         var id:int = 0;
         var props:Bitmap = null;
         id = MagpieBridgeManager.instance.magpieModel.NowPosition;
         if(id < this._mapVec.length - 1 && this._mapVec[id].numChildren >= 2)
         {
            this._mapVec[id].removeChildAt(1);
            props = ComponentFactory.Instance.creat("asset.magpieMap.props0");
            props.x = (this._mapVec[id].width - props.width) / 2;
            props.y = (this._mapVec[id].height - props.height) / 2;
            this._mapVec[id].addChild(props);
         }
      }
      
      private function getIconPos(preIcon:Sprite, curIcon:Sprite, iconId:int) : Point
      {
         var xPos:int = 0;
         var yPos:int = 0;
         if(iconId == 1)
         {
            xPos = preIcon.x - ICON_WIDTH;
            yPos = preIcon.y + (preIcon.height - curIcon.height) / 2;
         }
         else if(iconId == 2)
         {
            xPos = preIcon.x;
            yPos = preIcon.y - ICON_WIDTH;
         }
         else if(iconId == 3)
         {
            xPos = preIcon.x + ICON_WIDTH;
            yPos = preIcon.y + (preIcon.height - curIcon.height) / 2;
         }
         else if(iconId == 4)
         {
            xPos = preIcon.x;
            yPos = preIcon.y + ICON_WIDTH;
         }
         return new Point(xPos,yPos);
      }
      
      public function dispose() : void
      {
         ObjectUtils.removeChildAllChildren(this);
      }
      
      public function get mapVec() : Vector.<Sprite>
      {
         return this._mapVec;
      }
   }
}

