package yyvip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import yyvip.YYVipManager;
   
   public class YYVipLevelAwardCell extends Sprite implements Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _itemList:Vector.<YYVipLevelAwardItemCell>;
      
      public function YYVipLevelAwardCell(index:int)
      {
         var cell:YYVipLevelAwardItemCell = null;
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.yyvip.levelIcon" + index);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("yyvip.levelAwardCell.tipTxt");
         this._txt.text = LanguageMgr.GetTranslation("yyVip.dailyView.levelAwardCell.tipTxt",index);
         addChild(this._icon);
         addChild(this._txt);
         this._itemList = new Vector.<YYVipLevelAwardItemCell>();
         var tmp:Vector.<Object> = YYVipManager.instance.getDailyLevelVipAwardList(index);
         var len:int = int(tmp.length);
         for(var i:int = 0; i < len; i++)
         {
            cell = new YYVipLevelAwardItemCell(tmp[i]);
            cell.x = 170 + i * 108;
            cell.y = -1;
            addChild(cell);
            this._itemList.push(cell);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._icon = null;
         this._txt = null;
         this._itemList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

