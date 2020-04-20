#ifndef STOCKLISTMODEL_H
#define STOCKLISTMODEL_H
#include <QAbstractListModel>
#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class StockListModelPrivate;
class StockListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource)
public:
    StockListModel(QObject *parent = 0);
    ~StockListModel();
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE QVariant get(int index, int role) const;
    void update(int index, int role, QString value);
    QString source() const;
    void setSource(const QString& filePath);
    Q_INVOKABLE QString errorString() const;
    Q_INVOKABLE bool hasError() const;
    Q_INVOKABLE void reload();
    Q_INVOKABLE void remove(int index);
protected slots:
    void onTimeout();
    void onRefreshError(QNetworkReply::NetworkError code);
    void onRefreshFinished();
private:
    StockListModelPrivate *m_dptr;
    QTimer m_timer;
    QNetworkReply *m_reply;
    QNetworkAccessManager m_nam;
};

#endif // STOCKLISTMODEL_H
