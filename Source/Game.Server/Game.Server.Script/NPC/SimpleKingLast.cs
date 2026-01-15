// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SimpleKingLast
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SimpleKingLast : ABrain
  {
    public int attackingTurn = 1;
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
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 390 && allFightPlayer.X < 1110)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(390, 1110);
      }
      else
      {
        if (flag)
          return;
        if (this.attackingTurn == 1)
        {
          this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
          this.HalfAttack();
        }
        else if (this.attackingTurn == 2)
        {
          this.Body.Direction = -this.Body.Direction;
          this.Summon();
        }
        else if (this.attackingTurn == 3)
        {
          this.Body.Direction = -this.Body.Direction;
          this.Seal();
        }
        else if (this.attackingTurn == 4)
        {
          this.Body.Direction = -this.Body.Direction;
          this.Angger();
        }
        else
        {
          this.Body.Direction = -this.Body.Direction;
          this.GoOnAngger();
          this.attackingTurn = 0;
        }
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void HalfAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, SimpleKingLast.SealChat.Length);
      this.Body.Say(SimpleKingLast.AllAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      if (this.Body.Direction == 1)
        this.Body.RangeAttacking(this.Body.X, this.Body.X + 1000, "cry", 3300, (List<Player>) null);
      else
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X, "cry", 3300, (List<Player>) null);
    }

    public void Summon()
    {
      int index = this.Game.Random.Next(0, SimpleKingLast.CallChat.Length);
      this.Body.Say(SimpleKingLast.CallChat[index], 1, 0);
      this.Body.PlayMovie("beatA", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 2500);
    }

    public void Seal()
    {
      int index = this.Game.Random.Next(0, SimpleKingLast.SealChat.Length);
      this.Body.Say(SimpleKingLast.SealChat[index], 1, 0);
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.PlayMovie("mantra", 2000, 2000);
      this.Body.Seal(randomPlayer, 1, 3000);
    }

    public void Angger()
    {
      int index = this.Game.Random.Next(0, SimpleKingLast.AngryChat.Length);
      this.Body.Say(SimpleKingLast.AngryChat[index], 1, 0);
      this.Body.State = 1;
      this.Dander += 100;
      ((TurnedLiving) this.Body).SetDander(this.Dander);
      if (this.Body.Direction == -1)
        this.Body.SetRelateDemagemRect(8, -252, 74, 50);
      else
        this.Body.SetRelateDemagemRect(-82, -252, 74, 50);
    }

    public void GoOnAngger()
    {
      if (this.Body.State == 1)
      {
        this.Body.CurrentDamagePlus = 1000f;
        this.Body.PlayMovie("beatC", 3500, 0);
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 5600, (List<Player>) null);
        this.Body.Die(5600);
      }
      else
      {
        this.Body.SetRelateDemagemRect(-41, -187, 83, 140);
        this.Body.PlayMovie("mantra", 0, 2000);
        foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
          allLivingPlayer.AddEffect((AbstractEffect) new ContinueReduceBloodEffect(2, 50, (Living) allLivingPlayer), 0);
      }
    }

    public void KillAttack(int fx, int mx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, SimpleKingLast.KillAttackChat.Length);
      this.Body.Say(SimpleKingLast.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      this.Body.RangeAttacking(fx, mx, "cry", 3300, (List<Player>) null);
    }

    public void CreateChild() => ((SimpleBoss) this.Body).CreateChild(4, 520, 530, 400, 6, 1);
  }
}
