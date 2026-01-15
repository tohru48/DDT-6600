package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import flash.text.TextFormat;
   
   public class RoomPlayerItemIip extends BaseTip implements Disposeable, ITip
   {
      
      public static const MAX_HEIGHT:int = 70;
      
      public static const MIN_HEIGHT:int = 22;
      
      private var _textFrameArray:Vector.<FilterFrameText>;
      
      private var _contentLabel:TextFormat;
      
      private var _bg:ScaleBitmapImage;
      
      public function RoomPlayerItemIip()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         var _content:FilterFrameText = null;
         var _content2:FilterFrameText = null;
         var _content4:FilterFrameText = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTipsBG");
         addChild(this._bg);
         this._textFrameArray = new Vector.<FilterFrameText>();
         _content = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt");
         _content.visible = false;
         addChild(_content);
         this._textFrameArray.push(_content);
         _content2 = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt2");
         _content2.visible = false;
         addChild(_content2);
         this._textFrameArray.push(_content2);
         var _content3:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt3");
         _content3.visible = false;
         addChild(_content3);
         this._textFrameArray.push(_content3);
         _content4 = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt4");
         _content4.visible = false;
         addChild(_content4);
         this._textFrameArray.push(_content4);
         var _content5:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt5");
         _content5.visible = false;
         addChild(_content5);
         this._textFrameArray.push(_content5);
         this._contentLabel = ComponentFactory.Instance.model.getSet("ddtroom.roomPlayerItemTips.contentLabelTF");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         _tipData = data;
         if(Boolean(_tipData))
         {
            this.visible = true;
            this.reset();
            this.update();
         }
         else
         {
            this.visible = false;
         }
      }
      
      private function returnFilterFrameText(str:String) : FilterFrameText
      {
         var obj:FilterFrameText = null;
         var txt:FilterFrameText = null;
         for(var i:int = 0; i < this._textFrameArray.length; i++)
         {
            obj = this._textFrameArray[i];
            if(obj.text == "" || obj.text == str)
            {
               txt = obj;
               break;
            }
         }
         return obj;
      }
      
      private function isVisibleFunction() : void
      {
         var obj:FilterFrameText = null;
         var trueCount:int = 0;
         for each(obj in this._textFrameArray)
         {
            if(obj.text == "")
            {
               obj.visible = false;
            }
            else
            {
               trueCount++;
               obj.visible = true;
            }
         }
         if(trueCount == 0)
         {
            this.visible = false;
         }
      }
      
      private function reset() : void
      {
         var txt:FilterFrameText = null;
         for each(txt in this._textFrameArray)
         {
            txt.text = "";
         }
      }
      
      private function update() : void
      {
         var playerInfo:PlayerInfo = null;
         var i:int = 0;
         var pos:int = 0;
         var txt2:String = null;
         var contentTxt2:FilterFrameText = null;
         var pos3:int = 0;
         var txt3:String = null;
         var contentTxt3:FilterFrameText = null;
         var pos4:int = 0;
         var k:int = 0;
         var pos5:int = 0;
         var txt4:String = null;
         var contentTxt4:FilterFrameText = null;
         var pos6:int = 0;
         var txt5:String = null;
         var contentTxt5:FilterFrameText = null;
         var pos7:int = 0;
         if(_tipData is PlayerInfo)
         {
            playerInfo = _tipData as PlayerInfo;
            if(playerInfo.ID == playerInfo.ID)
            {
               if(playerInfo.apprenticeshipState == AcademyManager.MASTER_STATE || playerInfo.apprenticeshipState == AcademyManager.MASTER_FULL_STATE)
               {
                  for(i = 0; i <= (playerInfo.getMasterOrApprentices().length >= 3 ? 2 : playerInfo.getMasterOrApprentices().length); i++)
                  {
                     if(Boolean(playerInfo.getMasterOrApprentices().list[i]) && playerInfo.getMasterOrApprentices().list[i] != "")
                     {
                        this._textFrameArray[i].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.master",playerInfo.getMasterOrApprentices().list[i]);
                        pos = int(this._textFrameArray[i].text.indexOf(playerInfo.getMasterOrApprentices().list[i]));
                        this._textFrameArray[i].setTextFormat(this._contentLabel,pos,pos + playerInfo.getMasterOrApprentices().list[i].length);
                     }
                  }
               }
               else if(playerInfo.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
               {
                  if(Boolean(playerInfo.getMasterOrApprentices().list[0]) && playerInfo.getMasterOrApprentices().list[0] != "")
                  {
                     txt2 = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.Apprentice",playerInfo.getMasterOrApprentices().list[0]);
                     contentTxt2 = this.returnFilterFrameText(txt2);
                     if(Boolean(contentTxt2))
                     {
                        contentTxt2.text = txt2;
                        pos3 = int(txt2.indexOf(playerInfo.getMasterOrApprentices().list[0]));
                        contentTxt2.setTextFormat(this._contentLabel,pos,pos + playerInfo.getMasterOrApprentices().list[0].length);
                     }
                  }
               }
               if(playerInfo.IsMarried)
               {
                  txt3 = LanguageMgr.GetTranslation("ddt.room.roomPlayerItemTip.SpouseNameTxt",playerInfo.SpouseName);
                  contentTxt3 = this.returnFilterFrameText(txt3);
                  if(Boolean(contentTxt3))
                  {
                     pos4 = int(txt3.indexOf(playerInfo.SpouseName));
                     contentTxt3.text = txt3;
                     contentTxt3.setTextFormat(this._contentLabel,pos,pos + playerInfo.SpouseName.length);
                  }
               }
            }
            else
            {
               if(playerInfo.apprenticeshipState == AcademyManager.MASTER_STATE || playerInfo.apprenticeshipState == AcademyManager.MASTER_FULL_STATE)
               {
                  for(k = 0; k <= (playerInfo.getMasterOrApprentices().length >= 3 ? 2 : playerInfo.getMasterOrApprentices().length); k++)
                  {
                     if(Boolean(playerInfo.getMasterOrApprentices().list[k]) && playerInfo.getMasterOrApprentices().list[k] != "")
                     {
                        this._textFrameArray[k].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.master",playerInfo.getMasterOrApprentices().list[k]);
                        pos5 = int(this._textFrameArray[k].text.indexOf(playerInfo.getMasterOrApprentices().list[k]));
                        this._textFrameArray[k].setTextFormat(this._contentLabel,pos,pos + playerInfo.getMasterOrApprentices().list[k].length);
                     }
                  }
               }
               else if(playerInfo.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
               {
                  if(Boolean(playerInfo.getMasterOrApprentices().list[0]) && playerInfo.getMasterOrApprentices().list[0] != "")
                  {
                     txt4 = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.Apprentice",playerInfo.getMasterOrApprentices().list[0]);
                     contentTxt4 = this.returnFilterFrameText(txt4);
                     if(Boolean(contentTxt4))
                     {
                        contentTxt4.text = txt4;
                        pos6 = int(txt4.indexOf(playerInfo.getMasterOrApprentices().list[0]));
                        contentTxt4.setTextFormat(this._contentLabel,pos,pos + playerInfo.getMasterOrApprentices().list[0].length);
                     }
                  }
               }
               if(playerInfo.IsMarried)
               {
                  txt5 = LanguageMgr.GetTranslation("ddt.room.roomPlayerItemTip.SpouseNameTxt",playerInfo.SpouseName);
                  contentTxt5 = this.returnFilterFrameText(txt5);
                  if(Boolean(contentTxt5))
                  {
                     pos7 = int(txt5.indexOf(playerInfo.SpouseName));
                     contentTxt5.text = txt5;
                     contentTxt5.setTextFormat(this._contentLabel,pos,pos + playerInfo.SpouseName.length);
                  }
               }
            }
         }
         this.isVisibleFunction();
         this.updateBgSize();
      }
      
      private function updateBgSize() : void
      {
         this._bg.width = this.getMaxWidth();
         var length:int = 0;
         for(var i:int = 0; i < this._textFrameArray.length; i++)
         {
            if(this._textFrameArray[i].visible)
            {
               length++;
            }
         }
         this._bg.height = length * MIN_HEIGHT;
      }
      
      private function getMaxWidth() : int
      {
         var maxWidth:int = 0;
         for(var i:int = 0; i < this._textFrameArray.length; i++)
         {
            if(this._textFrameArray[i].visible && this._textFrameArray[i].width > maxWidth)
            {
               maxWidth = this._textFrameArray[i].width;
            }
         }
         return maxWidth + 10;
      }
      
      override public function dispose() : void
      {
         this._textFrameArray = null;
         if(Boolean(this._contentLabel))
         {
            this._contentLabel = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

