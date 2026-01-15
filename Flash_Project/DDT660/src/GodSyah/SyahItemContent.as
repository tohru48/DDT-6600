package GodSyah
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SyahItemContent extends Sprite
   {
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var _cellVec:Vector.<SyahSelfCell> = new Vector.<SyahSelfCell>();
      
      private var _index:int = -1;
      
      private var _content:Sprite;
      
      private var _alphaArr:Array;
      
      private var _tip:ScaleBitmapImage;
      
      private var _txt:FilterFrameText;
      
      public function SyahItemContent()
      {
         super();
         this._buildUI();
         this._addEvent();
         this.showContent();
         this._configEvent();
      }
      
      private function _buildUI() : void
      {
         var cell:SyahSelfCell = null;
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.leftBtn");
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.rightBtn");
         this._content = new Sprite();
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         addChild(this._content);
         var vec:Vector.<SyahMode> = SyahManager.Instance.syahItemVec;
         for(var i:int = 0; i < vec.length; i++)
         {
            cell = ComponentFactory.Instance.creatCustomObject("godSyah.syahview.syahselfcell");
            cell.shineEnable = vec[i].isHold && vec[i].isValid;
            cell.info = SyahManager.Instance.cellItems[i];
            this._cellVec.push(cell);
         }
         if(this._cellVec.length < 7)
         {
            this._leftBtn.visible = false;
            this._rightBtn.visible = false;
         }
      }
      
      private function _addEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__changeItem);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__changeItem);
      }
      
      private function __changeItem(e:MouseEvent) : void
      {
         var j:int = 0;
         var i:int = 0;
         var k:int = 0;
         var l:int = 0;
         switch(e.target)
         {
            case this._leftBtn:
               if(this._index > 5)
               {
                  this._removeAllChild();
                  for(j = this._index - 6,i = 0; i < 6; j++,i++)
                  {
                     this._content.addChild(this._cellVec[j]);
                     this._cellVec[j].x = 4 + i * 57;
                     this._cellVec[j].y = 4;
                     if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[j].info).isHold == false)
                     {
                        this._alphaArr[i].visible = true;
                        this._alphaArr[i].ishold = false;
                     }
                     else if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[j].info).isValid == false)
                     {
                        this._alphaArr[i].visible = true;
                        this._alphaArr[i].isvalid = false;
                     }
                     else
                     {
                        this._alphaArr[i].visible = false;
                     }
                  }
                  --this._index;
               }
               break;
            case this._rightBtn:
               if(this._index + 1 != this._cellVec.length)
               {
                  this._removeAllChild();
                  for(k = this._index - 4,l = 0; l < 6; k++,l++)
                  {
                     this._content.addChild(this._cellVec[k]);
                     this._cellVec[k].x = 4 + l * 57;
                     this._cellVec[k].y = 4;
                     if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[k].info).isHold == false)
                     {
                        this._alphaArr[l].visible = true;
                        this._alphaArr[l].ishold = false;
                     }
                     else if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[k].info).isValid == false)
                     {
                        this._alphaArr[l].visible = true;
                        this._alphaArr[l].isvalid = false;
                     }
                     else
                     {
                        this._alphaArr[l].visible = false;
                     }
                  }
                  ++this._index;
               }
         }
      }
      
      public function showContent() : void
      {
         var j:int = 0;
         var sp:MovieClip = null;
         this._alphaArr = new Array();
         for(j = 0; j < this._cellVec.length; j++)
         {
            if(this._index >= 5)
            {
               return;
            }
            this._content.addChild(this._cellVec[j]);
            this._cellVec[j].x = 4 + j * 57;
            this._cellVec[j].y = 4;
            ++this._index;
            sp = new MovieClip();
            sp.graphics.beginFill(16711680,0);
            sp.graphics.drawRect(0,0,47,47);
            sp.graphics.endFill();
            addChild(sp);
            sp.visible = false;
            sp.x = 3 + j * 57;
            sp.y = 3;
            this._alphaArr[j] = sp;
            sp.ishold = sp.isvalid = true;
            if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[j].info).isHold == false)
            {
               sp.visible = true;
               sp.ishold = false;
            }
            else if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[j].info).isValid == false)
            {
               sp.visible = true;
               sp.isvalid = false;
            }
         }
      }
      
      private function _configEvent() : void
      {
         for(var i:int = 0; i < this._alphaArr.length; i++)
         {
            this._alphaArr[i].addEventListener(MouseEvent.MOUSE_OVER,this.__overAlphaArea);
            this._alphaArr[i].addEventListener(MouseEvent.MOUSE_OUT,this.__outAlphaArea);
         }
      }
      
      private function __overAlphaArea(e:MouseEvent) : void
      {
         var sp:MovieClip = null;
         sp = e.target as MovieClip;
         if(this._tip == null)
         {
            this._tip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         }
         if(this._txt == null)
         {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahview.tip.txt");
         }
         if(sp.ishold == false)
         {
            this._txt.text = LanguageMgr.GetTranslation("ddt.GodSyah.syahview.tiptext1");
         }
         else if(sp.isvalid == false)
         {
            this._txt.text = LanguageMgr.GetTranslation("ddt.GodSyah.syahview.tiptext2");
         }
         this._txt.x = 10;
         this._txt.y = 10;
         this._tip.width = this._txt.width + 10;
         this._tip.height = this._txt.height + 20;
         this._tip.x = sp.x + sp.width / 2 - this._tip.width / 2;
         this._tip.y = sp.y - this._tip.height - 10;
         this._tip.addChild(this._txt);
         addChild(this._tip);
      }
      
      private function __outAlphaArea(e:MouseEvent) : void
      {
         if(Boolean(this._tip))
         {
            this._txt.text = "";
            this._txt = null;
            removeChild(this._tip);
            this._tip = null;
         }
      }
      
      private function _removeAllChild() : void
      {
         for(var i:int = 0; i < this._content.numChildren; i++)
         {
            this._content.removeChildAt(0);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._leftBtn))
         {
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(Boolean(this._rightBtn))
         {
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
         if(Boolean(this._tip))
         {
            ObjectUtils.disposeObject(this._tip);
            this._tip = null;
         }
         if(Boolean(this._txt))
         {
            ObjectUtils.disposeObject(this._txt);
            this._txt = null;
         }
      }
   }
}

