// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourTerrorGunNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourTerrorGunNpc : ABrain
  {
    public int attackingTurn = 1;
    private int npcID = 4103;
    private static string[] AllAttackChat = new string[4]
    {
      "看我的绝技！",
      "这招酷吧，<br/>想学不？",
      "消失吧！！！<br/>卑微的灰尘！",
      "你们会为此付出代价的！ "
    };
    private static string[] ShootChat = new string[5]
    {
      "你是在给我挠痒痒吗？",
      "我可不会像刚才那个废物一样被你打败！",
      "哎哟，你打的我好疼啊，<br/>哈哈哈哈！",
      "啧啧啧，就这样的攻击力！",
      "看到我是你们的荣幸！"
    };
    private static string[] CallChat = new string[1]
    {
      "来啊，<br/>让他们尝尝炸弹的厉害！"
    };
    private static string[] AngryChat = new string[1]
    {
      "是你们逼我使出绝招的！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "你来找死吗？"
    };
    private static string[] SealChat = new string[1]
    {
      "异次元放逐！"
    };
    private static string[] KillPlayerChat = new string[2]
    {
      "灭亡是你唯一的归宿！",
      "太不堪一击了！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      bool flag = false;
      int num1 = 0;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 400 && allFightPlayer.X < 1600)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(400, 1600);
      }
      else
      {
        if (flag)
          return;
        ((PVEGame) this.Game).SendGameObjectFocus(1, "door", 1000, 0);
        if (this.attackingTurn == 1)
          this.BestA();
        else if (this.attackingTurn == 2)
        {
          this.BestC();
        }
        else
        {
          this.BestB();
          this.attackingTurn = 0;
        }
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void BestB()
    {
      this.Body.PlayMovie("beatB", 0, 3000);
      List<SimpleNpc> simpleNpcList = new List<SimpleNpc>();
      foreach (Living liv in simpleNpcList)
      {
        if (liv is SimpleNpc)
        {
          simpleNpcList.Add(liv as SimpleNpc);
          liv.AddEffect((AbstractEffect) new ContinueReduceBloodEffect(2, 500, liv), 0);
        }
      }
    }

    public void BestA() => this.Body.PlayMovie("beatA", 1000, 0);

    public void BestC()
    {
      this.Body.PlayMovie("beatC", 1000, 0);
      this.Game.Random.Next(400, 1680);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 2500);
    }

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID, this.Game.Random.Next(470, 880), 700, 2, 400, -1);
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }
  }
}
