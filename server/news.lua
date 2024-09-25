local QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('z-phone:server:GetNews', function(source, body)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local query = [[
            SELECT 
                id,
                reporter,
                company,
                image,
                title,
                body,
                stream,
                is_stream,
                DATE_FORMAT(created_at, '%d %b %Y %H:%i') as created_at
            FROM zp_news WHERE is_stream = ? ORDER BY id DESC
        ]]
        local resultNews = MySQL.query.await(query, {false})
        local resultNewsStream = MySQL.query.await(query, {true})

        return {
            news = resultNews,
            streams = resultNewsStream,
        }
    end

    return {}
end)

lib.callback.register('z-phone:server:CreateNews', function(source, body)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local query = "INSERT INTO zp_news (citizenid, reporter, company, image, title, body, stream, is_stream) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"

        local id = MySQL.insert.await(query, {
            citizenid,
            Player.PlayerData.charinfo.firstname .. ' '.. Player.PlayerData.charinfo.lastname,
            Player.PlayerData.job.label,
            body.cover_url,
            body.title,
            body.content,
            body.stream_url,
            body.stream_url == "" and 0 or 1
        })

        if id then
            TriggerClientEvent("z-phone:client:sendNotifInternal", -1, {
                type = "Notification",
                from = "News",
                message = "News from ".. Player.PlayerData.job.label
            })
            return true
        else
            return false
        end
    end

    return false
end)