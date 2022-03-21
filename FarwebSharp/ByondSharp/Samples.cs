using ByondSharp.FFI;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using static BCrypt.Net.BCrypt;
using Discord;
using Discord.WebSocket;
using Discord.Commands;
using Discord.Rest;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using System.IO;
using System.Reflection;
using System.Linq;
using MySqlConnector;
using PasswordGenerator;
using System;
using Microsoft.Extensions.DependencyInjection;
namespace ByondSharp
{
    /// <summary>
    /// Stuff for Farweb.
    /// </summary>
    public class Samples
    {
        private static ulong ServerStatusId;
        private static DiscordSocketClient _client;
        private static DiscordRestClient _restClient;
        private static CommandService _commands;
        private static char configuredPrefix = '!';
        private static IServiceProvider _services;

        [ByondFFI]
        public static string Hash(List<string> password)
        {
            return HashPassword(password[0]);
        }

        [ByondFFI]
        public static string VerifyPassword(List<string> passwords)
        {
            var hash = passwords[0];
            var password = passwords[1];
            return Verify(password, hash).ToString();
        }

        [ByondFFI]
        public static async Task<string> OnRoundEnd(List<string> args)
        {
            var currentServer = args[0];
            var embed = new EmbedBuilder()
                .WithTitle($"{currentServer} has restarted!")
                .WithAuthor(new EmbedAuthorBuilder()
                    .WithName("Status Update")
                    .WithIconUrl("https://lfwb.ru/resources/assets/wiki.png?dbb52"))
                .WithThumbnailUrl(
                    "https://cdn.discordapp.com/attachments/795826584643960872/807345675049238559/eusoh.png")
                .WithColor(252, 3, 3)
                .WithCurrentTimestamp().Build();
            try
            {
                var _channel = (IRestMessageChannel) await _restClient.GetChannelAsync(ServerStatusId);
                await _channel.SendMessageAsync(embed: embed);
                await _client.StopAsync();
                await _client.LogoutAsync();
                await _restClient.LogoutAsync();
                return true.ToString();
            }
#if DEBUG
            catch (Exception e)
            {
                return e.ToString();
            }
#else
            catch
            {
                return false.ToString();
            }
#endif


        }

        [ByondFFI]
        public static async Task<string> OnRoundStart(List<string> args)
        {
            var currentServer = args[0];
            var port = args[1];
            var embed = new EmbedBuilder()
                .WithTitle($"{currentServer} is in lobby!")
                .WithFields(new EmbedFieldBuilder()
                    .WithName("IP")
                    .WithValue($"byond://iz.nopm.xyz:{port}")
                )
                .WithAuthor(new EmbedAuthorBuilder()
                    .WithName("Status Update")
                    .WithIconUrl("https://lfwb.ru/resources/assets/wiki.png?dbb52"))
                .WithFooter(new EmbedFooterBuilder()
                    .WithText("nopm.xyz/farwebwiki")
                    .WithIconUrl("https://lfwb.ru/resources/assets/wiki.png?dbb52"))
                .WithCurrentTimestamp()
                .WithColor(88, 53, 242)
                .WithThumbnailUrl(
                    "https://cdn.discordapp.com/attachments/795826584643960872/807345669055971439/armok.png")
                .Build();
            try
            {
                var _channel = (IRestMessageChannel) await _restClient.GetChannelAsync(ServerStatusId);
                await _channel.SendMessageAsync(embed: embed);
                return true.ToString();
            }
#if DEBUG
            catch (Exception e)
            {
                return e.ToString();
            }
#else
            catch
            {
                return false.ToString();
            }
#endif
        }

        [ByondFFI]
        public static async Task<string> Initialize()
        {
            string file = Directory.GetCurrentDirectory() + "\\discord.json";
            if (!File.Exists(file))
            {
                return "FILE NOT EXIST" + file;
            }

            var token = JObject.Parse(File.ReadAllText(file))["Token"].ToString();
            ServerStatusId = (ulong)JObject.Parse(File.ReadAllText(file))["server-status"];
            await DiscordInit(token);
            if (_restClient.LoginState == LoginState.LoggedIn && _client.LoginState == LoginState.LoggedIn)
            {
                return true.ToString();
            }
            else
            {
                return false.ToString();
            }

        }

        [ByondFFI(Deferrable = true)]
        public static async Task<string> HandleRegistration(List<string> args)
        {
            var _authToken = new Password(20).Next();
            var user = args[0];
            var Connection =
                new MySqlConnection("Server=nopm.xyz;User ID=nopm;Password=cb0C2NE50OqN2FmN;Database=farweb");
            await Connection.OpenAsync();
            var existsCommand =
                new MySqlCommand(
                    $"SELECT IF((SELECT register_token FROM playersfarweb WHERE ckey = \"{user}\") IS NULL, TRUE, FALSE)",
                    Connection);
            var result = await existsCommand.ExecuteReaderAsync();
            while (await result.ReadAsync())
            {
                if (!result.GetBoolean(0))
                {
                    return false.ToString();
                }
            }

            await existsCommand.DisposeAsync();
            await result.DisposeAsync();
            var command =
                new MySqlCommand($"UPDATE playersfarweb SET register_token = \"{_authToken}\" WHERE ckey = \"{user}\"",
                    Connection);
            try
            {
                await command.ExecuteNonQueryAsync();
            }
#if DEBUG
            catch (Exception e)
            {
                return e.ToString();
            }
#else
            catch
            {
                return "fail";
            }
#endif
            await command.DisposeAsync();
            await Connection.DisposeAsync();
            return _authToken;

        }

        [ByondFFI]
        public static async Task<string> HandleBan(List<string> args)
        {
            var ckey = args[0];
            ulong discord_id = 0;
            var Connection =
                new MySqlConnection("Server=nopm.xyz;User ID=nopm;Password=cb0C2NE50OqN2FmN;Database=farweb");
            await Connection.OpenAsync();
            var command = new MySqlCommand($"SELECT discord_id FROM playersfarweb WHERE ckey = \"{ckey}\"", Connection);
            var result = await command.ExecuteReaderAsync();
            while (await result.ReadAsync())
            {
                discord_id = result.GetUInt64(0);
            }

            await command.DisposeAsync();
            await result.DisposeAsync();
            try
            {

                var discordUser = await _client.GetGuild(748333632996900977).GetUsersAsync().Flatten()
                    .Where(x => x.Id == discord_id).SingleAsync();
                var role = _client.GetGuild(748333632996900977).GetRole(748333747325108255);
                await discordUser.RemoveRoleAsync(role);
            }
            catch
            {
                return false.ToString();
            }

            var discordIdUpdateQuery =
                new MySqlCommand(
                    $"UPDATE playersfarweb SET discord_id = NULL, register_token = NULL WHERE ckey = \"{ckey}\"",
                    Connection);
            await discordIdUpdateQuery.ExecuteNonQueryAsync();
            await discordIdUpdateQuery.DisposeAsync();
            await Connection.DisposeAsync();
            return true.ToString();

        }

        public static async Task DiscordInit(string Token)
        {
            _client = new DiscordSocketClient();
            _commands = new CommandService();
            _services = new ServiceCollection()
                .AddSingleton(_client)
                .AddSingleton(_commands)
                .BuildServiceProvider();
            await _commands.AddModuleAsync<Commands>(services: _services);
            await _client.LoginAsync(TokenType.Bot, Token);
            await _client.StartAsync();
            _client.MessageReceived += HandlePrivateMessage;
            _restClient = new DiscordRestClient();
            await _restClient.LoginAsync(TokenType.Bot, Token);




        }

        public static async Task HandlePrivateMessage(SocketMessage Param_message)
        {


            var message = Param_message as SocketUserMessage;
            if (message == null) return;
            var argPos = 0;
            if (message.HasCharPrefix(configuredPrefix, ref argPos) && !message.Author.IsBot &&
                (message.Author.Id != _client.CurrentUser.Id) && Param_message.Channel is SocketDMChannel)
            {
                var context = new SocketCommandContext(_client, message);
                await _commands.ExecuteAsync(context, argPos, _services);
            }
            else
            {
                var _channel = message.Channel;
                if (Param_message.Channel is SocketDMChannel && !message.Author.IsBot &&
                    (message.Author.Id != _client.CurrentUser.Id))
                {
                    await _channel.SendMessageAsync("Unknown command.");
                    return;
                }



            }
        }

        [ByondFFI(Deferrable = true)]
        public static async Task<string> ChromieAdjust(List<string> args)
        {
            var ckey = args[0].Split('&')[0];
            var value = args[0].Split('&')[1];
            var connection =
                new MySqlConnection("Server=nopm.xyz;User ID=nopm;Password=cb0C2NE50OqN2FmN;Database=farweb");
            await connection.OpenAsync();
            try
            {
                var queryChromie =
                    new MySqlCommand(
                        $"UPDATE playersfarweb SET chromosomes = chromosomes + {value} WHERE ckey = \"{ckey}\"",
                        connection);
                await queryChromie.ExecuteNonQueryAsync();
                await queryChromie.DisposeAsync();
            }
            catch
            {
                return false.ToString();
            }

            await connection.DisposeAsync();
            return true.ToString();

        }
        [ByondFFI(Deferrable = true)]
        public static async Task<string> HubbieInsert(List<string> args)
        {
            var ckey = args[0];
            var connection =
                new MySqlConnection("Server=nopm.xyz;User ID=nopm;Password=cb0C2NE50OqN2FmN;Database=farweb");
            await connection.OpenAsync();
            var command =
                new MySqlCommand($"INSERT INTO playersfarweb (ckey, reason) VALUES (\"{ckey}\", \"Hubbie\")",
                    connection);
            await command.ExecuteNonQueryAsync();
            await command.DisposeAsync();
            await connection.DisposeAsync();
            return true.ToString();
        }
    }

    public class Commands : ModuleBase<SocketCommandContext>
        {
            [Command("register", RunMode = RunMode.Async)]
            public async Task Register(string param)
            {
                if (param == null)
                {
                    await ReplyAsync("Token is empty.");
                    return;
                }
                var connection = new MySqlConnection("Server=nopm.xyz;User ID=nopm;Password=cb0C2NE50OqN2FmN;Database=farweb");
                await connection.OpenAsync();
                var tokenExists = new MySqlCommand($"SELECT IF((SELECT discord_id FROM playersfarweb WHERE register_token = \"{param}\") IS NULL, TRUE, FALSE)", connection);
                var result = await tokenExists.ExecuteReaderAsync();
                while (await result.ReadAsync())
                {
                    if (!result.GetBoolean(0))
                    {
                        await Context.Channel.SendMessageAsync("This register token has already been used. Register tokens may only be used once. Contact a Patriarch if you need assistance.");
                        return;
                    }
                }
                await result.DisposeAsync();
                await tokenExists.DisposeAsync();
                var query = new MySqlCommand($"SELECT IF(\"{param}\" IN (SELECT register_token FROM playersfarweb), TRUE, FALSE)", connection);
                var result2 = await query.ExecuteReaderAsync();
                while (await result2.ReadAsync())
                {
                    if (!result2.GetBoolean(0))
                    {
                        await Context.Channel.SendMessageAsync("This token is invalid. Please register in-game to receive your token.");
                        return;
                    }
                }
                await result2.DisposeAsync();
                await query.DisposeAsync();
                var idQuery = new MySqlCommand($"UPDATE playersfarweb SET discord_id = {Context.User.Id} WHERE register_token = \"{param}\"", connection);
                await idQuery.ExecuteNonQueryAsync();
                await idQuery.DisposeAsync();
                var ckeyQuery = new MySqlCommand($"SELECT ckey FROM playersfarweb WHERE register_token = \"{param}\"", connection);
                var ckeyResult = await ckeyQuery.ExecuteReaderAsync();
                string ckey = "";
                while (await ckeyResult.ReadAsync())
                {
                    ckey = ckeyResult.GetString(0);
                }
                await ckeyQuery.DisposeAsync();
                await ckeyResult.DisposeAsync();
                await connection.DisposeAsync();
                try
                {
                    var role = Context.Client.GetGuild(748333632996900977).GetRole(748333747325108255);
                    var user = await (from x in Context.Client.GetGuild(748333632996900977).GetUsersAsync().Flatten()
                                      where x.Id == Context.User.Id
                                      select x).SingleAsync();
                    await user.AddRoleAsync(role);
                    await user.ModifyAsync(x => x.Nickname = ckey);

                }
#if DEBUG
                catch (Exception e)
                {
                    await ReplyAsync(e.ToString());
                    return;
                }
#else
                catch
                {
                    await ReplyAsync("Something wrong occurred. Report this to Nopm.");
                    return;
                }
#endif
                await Context.Channel.SendMessageAsync("You have successfully registered.");
            }
        }
    }

