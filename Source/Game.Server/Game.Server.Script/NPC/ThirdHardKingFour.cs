// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdHardKingFour
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
  public class ThirdHardKingFour : ABrain
  {
    private int attackingTurn = 1;
    private int orchinIndex = 1;
    private int currentCount = 0;
    private int Dander = 0;
    private int npcID = 3203;
    private int IsEixt = 0;
    private PhysicalObj m_kingMoive;
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
      "Lửa địa ngục...",
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
      "Chạy đường nào đây?"
    };
    private static string[] KillPlayerChat = new string[1]
    {
      "Lửa bất diệt cháy bừng lên đi!"
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 572 && allFightPlayer.X < 872)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(572, 872);
      }
      else
      {
        if (flag)
          return;
        if (this.attackingTurn == 1)
          this.Summon();
        else if (this.attackingTurn == 2)
          this.PersonalAttackDame();
        else if (this.attackingTurn == 3)
          this.HalfAttack();
        else if (this.attackingTurn == 4)
          this.MovePlayer();
        else if (this.attackingTurn == 5)
        {
          this.PersonalNpc();
        }
        else
        {
          this.HalfAttack();
          this.attackingTurn = 1;
        }
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void HalfAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, ThirdHardKingFour.SealChat.Length);
      this.Body.Say(ThirdHardKingFour.AllAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      this.Body.RangeAttacking(this.Body.X - 2000, this.Body.Y + 2000, "cry", 3000, (List<Player>) null);
    }

    private void PersonalAttackDame()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      int index = this.Game.Random.Next(0, ThirdHardKingFour.ShootChat.Length);
      this.Body.Say(ThirdHardKingFour.ShootChat[index], 1, 500);
      int num;
      if (this.Body.X > randomPlayer.X)
      {
        if (randomPlayer.X > this.Body.Y)
          this.Body.ChangeDirection(1, 50);
        else
          this.Body.ChangeDirection(-1, 50);
        num = this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.X + 10);
        if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 53, 1000, 10000, 3, 2.3f, 2600))
        {
          this.Body.PlayMovie("aim", 1000, 0);
          this.Body.PlayMovie("beatA", 1500, 0);
        }
        if (!this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 53, 1000, 10000, 3, 2.3f, 4600))
          return;
        this.Body.PlayMovie("aim", 3000, 0);
        this.Body.PlayMovie("beatA", 4500, 0);
      }
      else
      {
        if (randomPlayer.X > this.Body.Y)
          this.Body.ChangeDirection(1, 50);
        else
          this.Body.ChangeDirection(-1, 50);
        num = this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.X + 10);
        if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 53, 1000, 10000, 3, 1f, 2600))
        {
          this.Body.PlayMovie("aim", 1000, 0);
          this.Body.PlayMovie("beatA", 1500, 0);
        }
        if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 53, 1000, 10000, 3, 1f, 4600))
        {
          this.Body.PlayMovie("aim", 3000, 0);
          this.Body.PlayMovie("beatA", 4500, 0);
        }
      }
    }

    private void PersonalNpc()
    {
      int index = this.Game.Random.Next(0, ThirdHardKingFour.CallChat.Length);
      this.Body.Say(ThirdHardKingFour.CallChat[index], 1, 500);
      if (this.IsEixt == 1)
      {
        this.Body.ChangeDirection(1, 50);
        if (this.Body.ShootPoint(1000, 560, 53, 1000, 10000, 1, 2f, 2550))
          this.Body.PlayMovie("aim", 1700, 0);
        this.Body.PlayMovie("beatA", 2000, 0);
        this.IsEixt = 0;
      }
      else
      {
        this.Body.ChangeDirection(-1, 50);
        if (this.Body.ShootPoint(478, 550, 53, 1000, 10000, 1, 2f, 2550))
          this.Body.PlayMovie("aim", 1700, 0);
        this.Body.PlayMovie("beatA", 2000, 0);
        this.IsEixt = 1;
      }
    }

    public void Summon()
    {
      if (this.Body.State == 1)
      {
        this.Body.PlayMovie("beatC", 2500, 0);
      }
      else
      {
        this.Body.PlayMovie("beatC", 0, 2000);
        List<Player> allLivingPlayers = this.Game.GetAllLivingPlayers();
        this.Game.FindRandomPlayer();
        int index = this.Game.Random.Next(0, ThirdHardKingFour.KillPlayerChat.Length);
        this.Body.Say(ThirdHardKingFour.KillPlayerChat[index], 1, 500);
        foreach (Player liv in allLivingPlayers)
          liv.AddEffect((AbstractEffect) new ContinueReduceBloodEffect(2, 500, (Living) liv), 0);
        this.Body.CallFuction(new LivingCallBack(this.In), 1300);
      }
    }

    public void In()
    {
      List<Player> allLivingPlayers = this.Game.GetAllLivingPlayers();
      this.Game.FindRandomPlayer();
      foreach (Player player in allLivingPlayers)
        this.m_kingMoive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(player.X, player.Y - 100, "moive", "asset.game.4.flame", "out", 1, 0);
      this.Body.CallFuction(new LivingCallBack(this.Remove), 1000);
    }

    public void Remove()
    {
      if (this.m_kingMoive == null)
        return;
      this.Game.RemovePhysicalObj(this.m_kingMoive, true);
      this.m_kingMoive = (PhysicalObj) null;
    }

    public void MovePlayer()
    {
      if (this.Body.State == 1)
      {
        this.Body.PlayMovie("beatC", 2500, 0);
      }
      else
      {
        this.Body.PlayMovie("beatC", 0, 2000);
        List<Player> allLivingPlayers = this.Game.GetAllLivingPlayers();
        this.Game.FindRandomPlayer();
        int index = this.Game.Random.Next(0, ThirdHardKingFour.SealChat.Length);
        this.Body.Say(ThirdHardKingFour.SealChat[index], 1, 500);
        foreach (Living living in allLivingPlayers)
          living.JumpToSpeed(this.Game.Random.Next(200, 1550), 400, "", 0, 0, 36, (LivingCallBack) null);
      }
    }

    public void KillAttack(int fx, int mx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirdHardKingFour.KillAttackChat.Length);
      this.Body.Say(ThirdHardKingFour.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatC", 2500, 0);
      this.Body.RangeAttacking(fx, mx, "cry", 3300, (List<Player>) null);
    }
  }
}
