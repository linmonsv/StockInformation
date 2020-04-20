#include "stocklistmodel.h"
#include <QXmlStreamReader>
#include <QVector>
#include <QFile>
#include <QDebug>
#include <QDateTime>
#include <QTextCodec>

typedef QVector<QString> StockData;
class StockListModelPrivate
{
public:
    StockListModelPrivate()
        :m_bError(false)
    {
        int role = Qt::UserRole;
        m_roleNames.insert(role++, "code");
        m_roleNames.insert(role++, "name");
        m_roleNames.insert(role++, "today_start_price");
        m_roleNames.insert(role++, "yesterday_end_price");
        m_roleNames.insert(role++, "current_price");
        m_roleNames.insert(role++, "today_highestLowest");
        m_roleNames.insert(role++, "trans_total");
        m_roleNames.insert(role++, "trans_amount");
        m_roleNames.insert(role++, "update_date_time");
    }
    ~StockListModelPrivate()
    {
        clear();
    }
    void load()
        {
            QXmlStreamReader reader;
            QFile file(m_strXmlFile);
            if(!file.exists())
            {
                m_bError = true;
                m_strError = "File Not Found";
                return ;
            }
            if(!file.open(QFile::ReadOnly))
            {
                m_bError = true;
                m_strError = file.errorString();
                return;
            }
            reader.setDevice(&file);
            QStringRef elementName;
            StockData* stock;
            while(!reader.atEnd())
            {
                reader.readNext();
                if(reader.isStartElement())
                {
                    elementName = reader.name();
                    if(elementName == "stock")
                    {
                        stock = new StockData();
                    }
                    else if(elementName == "code")
                    {
                        stock->append(reader.readElementText().toLatin1());
                    }
                    else if(elementName == "name")
                    {
                        stock->append(reader.readElementText().toUtf8());

                        stock->append("");
                        stock->append("");
                        stock->append("");
                        stock->append("");
                        stock->append("");
                        stock->append("");
                        stock->append("");
                    }
                }
                else if(reader.isEndElement())
                {
                    elementName = reader.name();
                    if(elementName == "stock")
                    {
                        m_stocks.append(stock);
                        stock = 0;
                    }
                }
            }
            file.close();
            if(reader.hasError())
            {
                m_bError = true;
                m_strError = reader.errorString();
            }
        }
    void reset()
    {
        m_bError = false;
        m_strError.clear();
        clear();
    }
    void clear()
    {
        int count = m_stocks.size();
        if(count > 0)
        {
            for(int i = 0; i < count; i ++)
            {
                delete m_stocks.at(i);
            }
            m_stocks.clear();
        }
    }
    QString m_strXmlFile;
    QString m_strError;
    bool m_bError;
    QHash<int, QByteArray> m_roleNames;
    QVector<StockData*> m_stocks;
};

StockListModel::StockListModel(QObject* parent)
    :QAbstractListModel(parent)
    , m_dptr(new StockListModelPrivate)
{
    qsrand(QDateTime::currentDateTime().toTime_t());
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    m_timer.start(3000);
}
StockListModel::~StockListModel()
{
    delete m_dptr;
}
int StockListModel::rowCount(const QModelIndex &parent) const
{
    return m_dptr->m_stocks.size();
}
QVariant StockListModel::data(const QModelIndex &index, int role) const
{
    StockData *d = m_dptr->m_stocks[index.row()];
    return d->at(role - Qt::UserRole);
}
QHash<int, QByteArray> StockListModel::roleNames() const
{
    return m_dptr->m_roleNames;
}
QVariant StockListModel::get(int index, int role) const
{
    StockData *d = m_dptr->m_stocks[index];
    return d->at(role);
}
void StockListModel::update(int index, int role, QString value)
{
    beginResetModel();
    (*m_dptr->m_stocks[index])[role] = value;
    endResetModel();
}
QString StockListModel::source() const
{
    return m_dptr->m_strXmlFile;
}
void StockListModel::setSource(const QString &filePath)
{
    m_dptr->m_strXmlFile = filePath;
    reload();
    if(m_dptr->m_bError)
    {
        qDebug() << "StockListModel, error - " << m_dptr->m_strError;
    }
}
QString StockListModel::errorString() const
{
    return m_dptr->m_strError;
}
bool StockListModel::hasError() const
{
    return m_dptr->m_bError;
}
void StockListModel::reload()
{
    beginResetModel();
    m_dptr->reset();
    m_dptr->load();
    endResetModel();
}
void StockListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    delete m_dptr->m_stocks.takeAt(index);
    endRemoveRows();
}
void StockListModel::onTimeout()
{
    QString strUrl_start = "http://hq.sinajs.cn/list=";
    QString strUrl = "";
    auto stock_total = m_dptr->m_stocks.size();
    for(auto i = 0; i < stock_total; i ++) {
        strUrl += get(i, 0).toString();
        if(i < stock_total - 1) {
            strUrl += ",";
        }
    }
    QUrl qurl(strUrl_start + strUrl);
    QNetworkRequest req(qurl);
    m_reply = m_nam.get(req);
    connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(onRefreshError(QNetworkReply::NetworkError)));
    connect(m_reply, SIGNAL(finished()), this, SLOT(onRefreshFinished()));
}

void StockListModel::onRefreshError(QNetworkReply::NetworkError code)
{
    m_reply->disconnect(this);
    m_reply->deleteLater();
    m_reply = 0;
}

void StockListModel::onRefreshFinished()
{
    m_reply->disconnect(this);
    if(m_reply->error() != QNetworkReply::NoError)
    {
        qDebug() << "StockProvider::refreshFinished, error - " << m_reply->errorString();
        return;
    }
    else if(m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() != 200)
    {
        qDebug() << "StockProvider::refreshFinished, but server return - " << m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        return;
    }
    QString Result = QString::fromLocal8Bit(m_reply->readAll());

    qDebug() << Result;
    auto stockArray = Result.split(";");
    for(auto index = 0; index < stockArray.size(); index ++) {
        if(stockArray[index].length() < 20)
            break;
        auto code_informations = stockArray[index].split("=");
        qDebug() << "code : " << code_informations[0].mid(14);
        auto informations = code_informations[1].split(",");
        qDebug() << "股票名字 : " << informations[0];
        qDebug() << "今日开盘价 : " << informations[1];
        qDebug() << "昨日收盘价 : " << informations[2];
        qDebug() << "当前价格 : " << informations[3];
        qDebug() << "今日最高/低价 : " << informations[4] + "/" + informations[5];
        qDebug() << "成交的股票数 : " << informations[8];
        qDebug() << "成交金额 : " << informations[9];
        qDebug() << "最近更新日期时间 : " << informations[30] + " " + informations[31];
        {
            update(index, 1, informations[0]);
            update(index, 2, informations[1]);
            update(index, 3, informations[2]);
            update(index, 4, informations[3]);
            update(index, 5, informations[4] + "/" + informations[5]);
            update(index, 6, QString("%1").arg(informations[8].toDouble() / 100.0));
            update(index, 7, QString("%1").arg(informations[9].toDouble() / 10000.0));
            update(index, 8, informations[30] + " " + informations[31]);
        }
    }

    m_reply->deleteLater();
    m_reply = 0;
}
