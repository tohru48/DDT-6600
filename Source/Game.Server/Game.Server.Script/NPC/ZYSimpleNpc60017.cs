// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ZYSimpleNpc60017
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ZYSimpleNpc60017 : ABrain
  {
    private int attackingTurn = 1;
    private int npcID = 1311;
    private static string[] AllAttackChat = new string[4]
    {
      "Xem tuyệt chiêu nè!",
      "Di chuyển mát mẻ!<br/>Bạn muốn tìm hiểu không?",
      "Chụi không nỗi!",
      "Bạn sẽ trả giá cho việc này! "
    };
    private static string[] CallChat = new string[1]
    {
      "Nào, <br/>cho thử sức mạnh của lựu đạn!"
    };
    private static string[] AngryChat = new string[1]
    {
      "Bạn buộc tôi để lừa!"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "Bạn đến chết?"
    };
    private static string[] SealChat = new string[1]
    {
      "Chầu Diêm Vương!"
    };
    private static string[] KillPlayerChat = new string[2]
    {
      "Địa ngục là điểm đến duy nhất của bạn!",
      "Quá dễ bị tổn thương."
    };
    public List<SimpleNpc> orchins = new List<SimpleNpc>();

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
      base.OnStartAttacking();
      bool flag = false;
      int num1 = 0;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 740 && allFightPlayer.X < 1040)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(620, 1160);
      }
      else
      {
        if (this.attackingTurn == 1)
        {
          this.Healing();
          this.HalfAttack();
        }
        else if (this.attackingTurn == 2)
        {
          this.Healing();
          this.Summon();
        }
        else if (this.attackingTurn == 3)
        {
          this.Healing();
          this.Seal();
        }
        else
        {
          this.Healing();
          this.attackingTurn = 0;
        }
        ++this.attackingTurn;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void HalfAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, ZYSimpleNpc60017.SealChat.Length);
      this.Body.Say(ZYSimpleNpc60017.AllAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      if (this.Body.Direction == 1)
        this.Body.RangeAttacking(this.Body.X, this.Body.X + 1000, "cry", 3300, (List<Player>) null);
      else
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X, "cry", 3300, (List<Player>) null);
    }

    public void Summon()
    {
      int index = this.Game.Random.Next(0, ZYSimpleNpc60017.CallChat.Length);
      this.Body.Say(ZYSimpleNpc60017.CallChat[index], 1, 0);
      this.Body.PlayMovie("beatA", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 2500);
    }

    public void Seal()
    {
      int index = this.Game.Random.Next(0, ZYSimpleNpc60017.SealChat.Length);
      this.Body.Say(ZYSimpleNpc60017.SealChat[index], 1, 0);
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.PlayMovie("mantra", 2000, 2000);
      this.Game.GetAllLivingPlayers();
      this.Body.Seal(randomPlayer, 1, 3000);
    }

    public void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ZYSimpleNpc60017.KillAttackChat.Length);
      this.Body.Say(ZYSimpleNpc60017.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3300, (List<Player>) null);
    }

    public void Healing()
    {
      this.Body.SyncAtTime = true;
      this.Body.AddBlood(5000);
      this.Body.Say("Haha, tôi là đầy sức mạnh!", 1, 0);
    }

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID, 680, 680, 405, 6, -1);
    }
  }
}
