#include "stocklistmodel.h"
#include <QXmlStreamReader>
#include <QVector>
#include <QFile>
#include <QDebug>
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
        m_roleNames.insert(role++, "latestPrice");
        m_roleNames.insert(role++, "change");
        m_roleNames.insert(role++, "quoteChange");
        m_roleNames.insert(role++, "highestLowest");
        m_roleNames.insert(role++, "takeProfitStopLoss");
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
                    }
                    else if(elementName == "latestPrice")
                    {
                        stock->append(reader.readElementText().toLatin1());
                    }
                    else if(elementName == "change")
                    {
                        stock->append(reader.readElementText().toLatin1());
                    }
                    else if(elementName == "quoteChange")
                    {
                        stock->append(reader.readElementText().toLatin1());
                    }
                    else if(elementName == "highestLowest")
                    {
                        stock->append(reader.readElementText().toLatin1());
                    }
                    else if(elementName == "takeProfitStopLoss")
                    {
                        stock->append(reader.readElementText().toLatin1());
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
