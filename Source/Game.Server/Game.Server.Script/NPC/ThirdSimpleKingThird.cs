// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdSimpleKingThird
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdSimpleKingThird : ABrain
  {
    private int attackingTurn = 1;
    private int orchinIndex = 1;
    private int currentCount = 0;
    private int Dander = 0;
    private int npcID = 3003;
    private int npcID2 = 3112;
    private int npcID1 = 3013;
    public List<SimpleNpc> orchins = new List<SimpleNpc>();
    private static string[] AllAttackChat = new string[4]
    {
      "Tiếng gầm của mảnh hổ !!...",
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
      "Vũ điệu<br/>săn bắn...."
    };
    private static string[] AngryChat = new string[1]
    {
      "是你们逼我使出绝招的！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "Muốn xem lợi hại của cổ họng của ta!"
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 592 && allFightPlayer.X < 872)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(592, 872);
      }
      else
      {
        if (flag)
          return;
        if (this.attackingTurn == 1)
          this.HalfAttack();
        else if (this.attackingTurn == 2)
          this.PersonalAttack();
        else if (this.attackingTurn == 3)
          this.Summon();
        else if (this.attackingTurn == 4)
        {
          this.PersonalAttackDame();
        }
        else
        {
          this.SummonNpc();
          this.attackingTurn = 1;
        }
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking()
    {
      base.OnStopAttacking();
      this.Game.RemoveLiving(this.npcID);
    }

    public void HalfAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, ThirdSimpleKingThird.SealChat.Length);
      this.Body.Say(ThirdSimpleKingThird.AllAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatC", 2500, 0);
      this.Body.RangeAttacking(this.Body.X - 2000, this.Body.Y + 2000, "cry", 3000, (List<Player>) null);
    }

    private void PersonalAttackDame()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Game.FindRandomPlayer();
      this.Game.FindRandomPlayer();
      if (randomPlayer.X > this.Body.Y)
        this.Body.ChangeDirection(1, 800);
      else
        this.Body.ChangeDirection(-1, 800);
      if (randomPlayer == null)
        return;
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 55, 1000, 10000, 1, 1.5f, 2550))
        this.Body.PlayMovie("beatB", 1700, 0);
    }

    private void PersonalAttack()
    {
      this.Body.MoveTo(this.Game.Random.Next(700, 800), this.Body.Y, "walk", 1000, "", 3, new LivingCallBack(this.NextAttack));
    }

    private void NextAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Game.FindRandomPlayer();
      this.Game.FindRandomPlayer();
      if (randomPlayer.X > this.Body.Y)
        this.Body.ChangeDirection(1, 800);
      else
        this.Body.ChangeDirection(-1, 800);
      if (randomPlayer == null)
        return;
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 54, 1000, 10000, 1, 1.5f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    public void Summon()
    {
      int index = this.Game.Random.Next(0, ThirdSimpleKingThird.CallChat.Length);
      this.Body.Say(ThirdSimpleKingThird.CallChat[index], 1, 0);
      this.Body.PlayMovie("callA", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild2), 2500);
    }

    public void SummonNpc()
    {
      int index = this.Game.Random.Next(0, ThirdSimpleKingThird.CallChat.Length);
      this.Body.Say(ThirdSimpleKingThird.CallChat[index], 1, 0);
      this.Body.PlayMovie("callB", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 2500);
    }

    public void KillAttack(int fx, int mx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirdSimpleKingThird.KillAttackChat.Length);
      this.Body.Say(ThirdSimpleKingThird.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatC", 2500, 0);
      this.Body.RangeAttacking(fx, mx, "cry", 3300, (List<Player>) null);
    }

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID, 520, 395, 50, 6, -1);
    }

    public void CreateChild2()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID2, this.Game.Random.Next(100, 400), 395, this.Game.Random.Next(150, 300), 6, -1);
    }
  }
}
