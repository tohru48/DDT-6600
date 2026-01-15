package luckStar.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarAwardView extends Sprite implements Disposeable
   {
      
      private var bg:Bitmap;
      
      private var _closeBtn:BaseButton;
      
      private var _list:Vector.<BaseCell>;
      
      private var _countList:Vector.<FilterFrameText>;
      
      public function LuckStarAwardView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._countList = new Vector.<FilterFrameText>();
         this.bg = ComponentFactory.Instance.creat("luckyStar.view.AwardListBG");
         this._closeBtn = ComponentFactory.Instance.creat("luckyStar.view.RankBtn");
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__onClose);
         addChild(this.bg);
         addChild(this._closeBtn);
         this.updateView();
      }
      
      private function updateView() : void
      {
         var awardList:Vector.<InventoryItemInfo> = null;
         var quality:int = 0;
         var i:int = 0;
         var text:FilterFrameText = null;
         var qualityList:Array = [11,12,13,14,15,16];
         awardList = LuckStarManager.Instance.model.reward;
         var len:int = int(awardList.length);
         var index:int = 0;
         this._list = new Vector.<BaseCell>(len);
         while(Boolean(qualityList.length))
         {
            quality = int(qualityList.shift());
            index = 0;
            for(i = 0; i < len; i++)
            {
               if(awardList[i].Quality == quality)
               {
                  this._list[i] = new BaseCell(ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.awardcellBg"));
                  this._list[i].info = awardList[i];
                  this._list[i].info.Quality = ItemManager.Instance.getTemplateById(awardList[i].TemplateID).Quality;
                  PositionUtils.setPos(this._list[i],"luckyStar.view.awardPos" + quality + index);
                  addChild(this._list[i]);
                  if(awardList[i].Count > 1)
                  {
                     text = ComponentFactory.Instance.creat("luckyStar.view.cellCount");
                     text.text = awardList[i].Count.toString();
                     text.x = this._list[i].x - 12;
                     text.y = this._list[i].y + 25;
                     addChild(text);
                     this._countList.push(text);
                  }
                  index++;
               }
            }
         }
      }
      
      private function __onClose(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.parent.removeChild(this);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this.bg);
         this.bg = null;
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__onClose);
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         while(Boolean(this._list.length))
         {
            ObjectUtils.disposeObject(this._list.pop());
         }
         this._list = null;
         while(Boolean(this._countList.length))
         {
            ObjectUtils.disposeObject(this._countList.pop());
         }
         this._countList = null;
      }
   }
}

