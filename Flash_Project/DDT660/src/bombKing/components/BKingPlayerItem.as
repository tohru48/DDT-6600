package bombKing.components
{
   import bombKing.data.BKingPlayerInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class BKingPlayerItem extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _playerName:FilterFrameText;
      
      private var _info:BKingPlayerInfo;
      
      private var _place:int;
      
      private var _curStatus:int;
      
      private var _pos:Point;
      
      public function BKingPlayerItem(place:int)
      {
         super();
         this._place = place;
         this.initView();
      }
      
      private function initView() : void
      {
         if(this._place < 16)
         {
            if(this._place < 8)
            {
               if(this._place < 4)
               {
                  this._bg = ClassUtils.CreatInstance("bombKing.top2Bg");
                  this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item2Txt");
               }
               else
               {
                  this._bg = ClassUtils.CreatInstance("bombKing.top4Bg");
                  this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item4Txt");
               }
            }
            else
            {
               this._bg = ClassUtils.CreatInstance("bombKing.top8Bg");
               this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item8Txt");
            }
         }
         else
         {
            this._bg = ClassUtils.CreatInstance("bombKing.top16Bg");
            this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item16Txt");
         }
         this._bg.gotoAndStop(1);
         this._pos = new Point(this._playerName.x,this._playerName.y);
         addChild(this._bg);
         addChild(this._playerName);
      }
      
      public function set info(info:BKingPlayerInfo) : void
      {
         this._info = info;
         if(Boolean(this._info))
         {
            if(this._info.status != this._curStatus)
            {
               this._curStatus = this._info.status;
               switch(this._curStatus)
               {
                  case -1:
                     this._bg.gotoAndStop(3);
                     break;
                  case 0:
                     this._bg.gotoAndStop(1);
                     break;
                  case 1:
                     this._bg.gotoAndStop(2);
               }
               this.setNameTxtStyle();
            }
            this._playerName.text = this._info.name;
         }
         else
         {
            this._bg.gotoAndStop(1);
            this._playerName.text = "";
         }
      }
      
      public function get info() : BKingPlayerInfo
      {
         return this._info;
      }
      
      private function setNameTxtStyle() : void
      {
         ObjectUtils.disposeObject(this._playerName);
         this._playerName = null;
         switch(this._curStatus)
         {
            case 0:
               if(this._place < 16)
               {
                  if(this._place < 8)
                  {
                     if(this._place < 4)
                     {
                        this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item2Txt");
                     }
                     else
                     {
                        this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item4Txt");
                     }
                  }
                  else
                  {
                     this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item8Txt");
                  }
               }
               else
               {
                  this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.item16Txt");
               }
               break;
            case -1:
               this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.itemDarkTxt");
               this._playerName.x = this._pos.x;
               this._playerName.y = this._pos.y;
               break;
            case 1:
               this._playerName = ComponentFactory.Instance.creatComponentByStylename("bombKing.itemLightTxt");
               this._playerName.x = this._pos.x;
               this._playerName.y = this._pos.y;
         }
         addChild(this._playerName);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._playerName);
         this._playerName = null;
      }
   }
}

