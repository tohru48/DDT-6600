// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenHardThirdBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirteenHardThirdBoss : ABrain
  {
    public int attackingTurn = 0;
    public int orchinIndex = 1;
    public int currentCount = 0;
    public int Dander = 0;
    public List<SimpleNpc> orchins = new List<SimpleNpc>();
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(0, 0);
      }
      else
      {
        this.Body.DoAction = -1;
        if (this.attackingTurn == 0)
          ++this.attackingTurn;
        else if (this.attackingTurn == 1)
        {
          this.Jump();
          ++this.attackingTurn;
        }
        else
        {
          this.Run();
          this.attackingTurn = 0;
        }
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void Jump()
    {
      this.Body.PlayMovie("jump", 1000, 6000);
      this.Body.JumpToSpeed(this.Game.FindRandomPlayer().X, this.Body.Y - 1000, "", 2500, 1, 10, new LivingCallBack(this.fall));
    }

    public void fall()
    {
      this.Body.CurrentDamagePlus = 3f;
      this.Body.PlayMovie(nameof (fall), 0, 0);
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 0, (List<Player>) null);
    }

    private void StandC()
    {
      this.Body.PlayMovie("standC", 0, 0);
      this.Body.DoAction = 5;
    }

    private void Run()
    {
      this.Body.CurrentDamagePlus = 5f;
      this.Body.MoveTo(this.Game.Random.Next(1800, 1800), this.Body.Y, "walk", 1000, "", 25, new LivingCallBack(this.JumpBack));
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 1000, (List<Player>) null);
    }

    public void JumpBack()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("jump", 1000, 6000);
      this.Body.JumpToSpeed(this.Game.FindRandomPlayer().X, this.Body.Y - 1000, "", 2500, 1, 10, new LivingCallBack(this.FallBack));
    }

    public void FallBack()
    {
      this.Body.PlayMovie("fall", 0, 0);
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      int index = this.Game.Random.Next(0, ThirteenHardThirdBoss.KillAttackChat.Length);
      this.Body.Say(ThirteenHardThirdBoss.KillAttackChat[index], 1, 1000);
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }
  }
}
