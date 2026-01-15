package kingDivision.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import kingDivision.data.KingDivisionConsortionItemInfo;
   
   public class KingDivisionConsortionListItem extends Sprite implements Disposeable
   {
      
      private var _itemBG:ScaleFrameImage;
      
      private var _index:int;
      
      private var _consortionName:FilterFrameText;
      
      private var _points:FilterFrameText;
      
      private var _count:FilterFrameText;
      
      private var _level:FilterFrameText;
      
      private var _topThreeRink:ScaleFrameImage;
      
      private var _ring:FilterFrameText;
      
      public function KingDivisionConsortionListItem(index:int)
      {
         super();
         this._index = index;
         this.init();
      }
      
      private function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("kingDivision.consortionClub.MemberListItem");
         if(this._index % 2 == 0)
         {
            this._itemBG.setFrame(2);
         }
         else
         {
            this._itemBG.setFrame(1);
         }
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("kingDivision.consortionName");
         this._consortionName.text = "惶籽";
         this._count = ComponentFactory.Instance.creatComponentByStylename("kingDivision.count");
         this._count.text = "50";
         this._points = ComponentFactory.Instance.creatComponentByStylename("kingDivision.points");
         this._points.text = "3550";
         this._level = ComponentFactory.Instance.creatComponentByStylename("kingDivision.level");
         this._level.text = "10";
         this._topThreeRink = ComponentFactory.Instance.creat("kingDivision.toffilist.topThreeRink");
         this._topThreeRink.visible = false;
         this._ring = ComponentFactory.Instance.creatComponentByStylename("kingDivision.ring");
         addChild(this._itemBG);
         addChild(this._consortionName);
         addChild(this._count);
         addChild(this._points);
         addChild(this._level);
         addChild(this._topThreeRink);
         addChild(this._ring);
         this.setRink();
      }
      
      public function set info(info:KingDivisionConsortionItemInfo) : void
      {
         this._consortionName.text = String(info.consortionName);
         this._count.text = String(info.num);
         this._level.text = String(info.consortionLevel);
         this._points.text = String(info.points);
      }
      
      private function setRink() : void
      {
         if(this._index < 4)
         {
            this._topThreeRink.visible = true;
            this._topThreeRink.setFrame(this._index);
            return;
         }
         this._ring.text = this._index + "th";
      }
      
      override public function get height() : Number
      {
         if(this._itemBG == null)
         {
            return 0;
         }
         return this._itemBG.y + this._itemBG.height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemBG = null;
         this._consortionName = null;
         this._count = null;
         this._level = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

